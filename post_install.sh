# post_install.sh
#!/bin/bash
sed -i 's/cmake_minimum_required(VERSION 2.8.12)/cmake_minimum_required(VERSION 3.10...3.25)/g' build/windows/x64/extracted/firebase_cpp_sdk_windows/CMakeLists.txt