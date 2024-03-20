#!/bin/sh

# Initialize Conda for Bash
eval "$(conda shell.bash hook)"

# Define the output directory for Mugsy
output_dir="/path/wga/mugsy/output"

# Create a log file to store execution times
log_file="$output_dir/execution_times.log"

# Start measuring the total execution time
total_start_time=$(date +%s.%N)

# Activate the Conda environment for Mugsy
echo "Step: Activate Conda Environment for Mugsy - Started at $(date)" >> "$log_file"
conda activate mugsy_env  # Replace 'mugsy_env' with your Mugsy environment name
echo "Step: Activate Conda Environment for Mugsy - Completed at $(date)" >> "$log_file"

# Define paths to the input genome FASTA files
genome1="/path/wga/genomes/human_genome1.fasta"
genome2="/path/wga/genomes/human_genome2.fasta"

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# Run Mugsy
echo "Step: Run Mugsy - Started at $(date)" >> "$log_file"
mugsy --directory "$output_dir" --prefix mygenomes "$genome1" "$genome2"
echo "Step: Run Mugsy - Completed at $(date)" >> "$log_file"

# Deactivate the Conda environment
echo "Step: Deactivate Conda Environment - Started at $(date)" >> "$log_file"
conda deactivate
echo "Step: Deactivate Conda Environment - Completed at $(date)" >> "$log_file"

# Stop measuring the total execution time
total_end_time=$(date +%s.%N)

# Calculate and print the total execution time
total_execution_time=$(echo "$total_end_time - $total_start_time" | bc)
echo "Total Execution Time: $total_execution_time seconds" >> "$log_file"

