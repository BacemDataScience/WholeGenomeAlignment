#!/bin/sh

# Initialize Conda for Bash
eval "$(conda shell.bash hook)"

# Define the output directory
output_dir="/home/saadab/wga/mummer4/outputc"

# Create a log file to store execution times and script outputs
log_file="$output_dir/execution_log.log"
script_output_log="$output_dir/script_output.log"

# Start measuring the total execution time
total_start_time=$(date +%s.%N)

# Activate the 'mummer4' environment
echo "Step: Activate Conda Environment - Started at $(date)" >> "$log_file"
conda activate mummer4
echo "Step: Activate Conda Environment - Completed at $(date)" >> "$log_file"

# Define paths to the input genome FASTA files
genome1="/home/saadab/wga/genomes/celegans.fna"
genome2="/home/saadab/wga/genomes/yeast.fna"

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# Run the MUMmer 4 commands for comparative genomics
echo "Step: Run nucmer - Started at $(date)" >> "$log_file"
nohup nucmer -p "$output_dir/comparison_output" "$genome1" "$genome2" > "$script_output_log" 2>&1 &
echo "Step: Run nucmer - Completed at $(date)" >> "$log_file"

echo "Step: Run delta-filter - Started at $(date)" >> "$log_file"
nohup delta-filter -1 -l 1000 -i 90 -o 10 "$output_dir/comparison_output.delta" > "$output_dir/filtered_comparison.delta" >> "$script_output_log" 2>&1 &
echo "Step: Run delta-filter - Completed at $(date)" >> "$log_file"

echo "Step: Run mummerplot - Started at $(date)" >> "$log_file"
nohup mummerplot -p "$output_dir/comparison_plot" -l -t png "$output_dir/filtered_comparison.delta" >> "$script_output_log" 2>&1 &
echo "Step: Run mummerplot - Completed at $(date)" >> "$log_file"

echo "Step: Run show-coords - Started at $(date)" >> "$log_file"
nohup show-coords -rcl "$output_dir/filtered_comparison.delta" > "$output_dir/comparison_coords.txt" >> "$script_output_log" 2>&1 &
echo "Step: Run show-coords - Completed at $(date)" >> "$log_file"

# Deactivate the Conda environment
echo "Step: Deactivate Conda Environment - Started at $(date)" >> "$log_file"
conda deactivate
echo "Step: Deactivate Conda Environment - Completed at $(date)" >> "$log_file"

# Stop measuring the total execution time
total_end_time=$(date +%s.%N)

# Calculate and print the total execution time
total_execution_time=$(echo "$total_end_time - $total_start_time" | bc)
echo "Total Execution Time: $total_execution_time seconds" >> "$log_file"

