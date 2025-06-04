#!/bin/bash

kill_dotnet_by_project() {
    local project_path=$1
    echo "Killing dotnet processes for project: $project_path"

    # Lấy PID các process dotnet có command line chứa đường dẫn project
    pids=$(ps aux | grep dotnet | grep "$project_path" | grep -v grep | awk '{print $2}')

    if [ -z "$pids" ]; then
        echo "No dotnet process found for $project_path"
    else
        echo "Killing PIDs: $pids"
        kill -9 $pids
    fi
}

# Duyệt qua từng thư mục con *.Api
for dir in */*.Api/; do
    if [ -d "$dir" ]; then
        kill_dotnet_by_project "$dir"
    fi
done
