#include <libpressio_ext/cpp/printers.h>
#include <libpressio_ext/cpp/io.h>
#include <libpressio_ext/cpp/compressor.h>
#include <libpressio_predict_ext/cpp/scheme.h>
#include <libpressio_meta.h>
#include <libpressio_ext/io/pressio_io.h>
#include <iostream>
#include <chrono>
#include <filesystem>
#include <fstream>
#include <cstdlib>   // std::system / popen
#include <cstdio>    // popen, fgets

using namespace libpressio::predict;
namespace fs = std::filesystem;

int main() {
    libpressio_register_all();

    /* ---------- 打开/创建 CSV 文件 ---------- */
    std::ofstream csv("results.csv");
    if(!csv) {
        std::cerr << "cannot open results.csv\n";
        return 1;
    }
    csv << "file,compression_time,compression_ratio\n";   // 写表头

    auto plugins      = scheme_plugins();
    auto khan_scheme  = plugins.build("tao2019");
    pressio_options settings {
	    {"pressio:compressor", "sz"},
	    {"pressio:rel", 1e-2},
	  {"predictors:all", true}
   
   
    };

    auto raw_io = io_plugins().build("posix");
    std::string folder_path = "/home/ziweiq2/LibPressio/dataset/100x500x500";

    std::vector<fs::directory_entry> files;
    for (const auto& entry : fs::directory_iterator(folder_path))
        if (entry.is_regular_file()) files.push_back(entry);

    std::sort(files.begin(), files.end(),
              [](auto const& a, auto const& b){ return a.path() < b.path(); });

    for (const auto& entry : files) {
        std::string file_path_full = entry.path().string();              // full path for processing
    	std::string file_name_only = entry.path().filename().string();   // just filename for CSV/log


        std::cout << "Processing: " << file_path_full << std::endl;

        raw_io->set_options({
            {"io:path", file_path_full}
          //  {"pressi:rel", 1e-3},
           // {"predictors:all", true}
        });

        pressio_data metadata = pressio_data::owning(pressio_float_dtype, {500,500,100});
        pressio_data* input   = raw_io->read(&metadata);

        pressio_data compressed = pressio_data::empty(pressio_float_dtype,{});
        pressio_data output     = pressio_data::owning(*input);

        pressio_compressor comp = compressor_plugins().build("pressio");
        auto predictor = khan_scheme->get_predictor(comp);

        auto t0 = std::chrono::high_resolution_clock::now();
        pressio_data features = khan_scheme->get_features(comp, settings, *input,
                                                          compressed, output, {});
        auto t1 = std::chrono::high_resolution_clock::now();
        long duration = std::chrono::duration_cast<std::chrono::milliseconds>(t1-t0).count();

        pressio_data labels = pressio_data::owning(pressio_float_dtype,
                                                   {khan_scheme->get_label_ids().size()});
        predictor->predict(features, labels);

        double* ptr = static_cast<double*>(labels.data());
        double ptr0 = ptr[0];

        /* ---------- 打印并写 CSV ---------- */
        std::cout << "  compression time: " << duration
                  << " | compression ratio: "     << ptr0 << "\n";
        csv << file_name_only << ',' << duration << ',' << ptr0 << '\n';
    }

    csv.close();
    std::cout << "\nResults written to results.csv\n\n";

    /* ---------- 排版并直接输出 CSV ---------- */
    FILE* pipe = popen("column -s, -t results.csv", "r");
    if(!pipe) {
        perror("popen");
        return 1;
    }
    char buffer[256];
    while(fgets(buffer, sizeof(buffer), pipe) != nullptr) {
        std::cout << buffer;
    }
    pclose(pipe);

    return 0;
}

