#!/bin/bash

echo "Stopping any existing dotnet services..."

# Hàm kill process dotnet theo project path
kill_dotnet_by_project() {
    local project_path=$1
    echo "Killing dotnet processes for: $project_path"

    # Tìm các PID chứa đường dẫn thư mục project đang chạy
    pids=$(ps aux | grep dotnet | grep "$project_path" | grep -v grep | awk '{print $2}')
    
    if [ -n "$pids" ]; then
        echo "Killing PIDs: $pids"
        kill -9 $pids
    else
        echo "No running process found for $project_path"
    fi
}

echo "Starting all API services..."
for dir in */*.Api/; do
    if [ -d "$dir" ]; then
        echo ""
        echo "→ Preparing $dir"
        kill_dotnet_by_project "$dir"

        echo "→ Starting service in $dir"
        (cd "$dir" && dotnet run) &
    fi
done

# Wait cho tất cả các process chạy nền nếu cần
wait
