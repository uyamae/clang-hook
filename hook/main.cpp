#include <iostream>
#include <filesystem>

/**
 * @brief rsp ファイルを処理する
 * @param[in] rsp_path rsp ファイルのフルパス
 */
void process_rsp(const char * rsp_path)
{
    std::filesystem::path src_path{ rsp_path };
    std::filesystem::path dst_path = std::filesystem::current_path() / std::filesystem::path(rsp_path).filename();
    // コピー元とコピー先の確認
    std::wcout << L"copy " << src_path << " to " << dst_path << std::endl; 
    // ファイルをコピー
    std::filesystem::copy_file(src_path, dst_path);
}

int main(int argc, char ** argv)
{
    // 引数をすべて表示する
    for (int i = 0; i < argc; ++i) {
        std::cout << argv[i] << std::endl;
        // @ で始まっていたらrsp ファイルパスとみなして処理する
        if (argv[i][0] == '@') {
            process_rsp(argv[i] + 1);
        }
    }
    return 1;
}