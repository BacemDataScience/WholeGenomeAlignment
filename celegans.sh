#!/bin/sh

# Initialize Conda for Bash
eval "$(conda shell.bash hook)"

# Define the output directory for SibeliaZ
output_dir="/path/wga/sibeliaz/outputc"

# Create a log file to store execution times
log_file="$output_dir/execution_times.log"
script_output_log="$output_dir/script_output.log"

# Start measuring the total execution time
total_start_time=$(date +%s.%N)

# Activate the Conda environment for SibeliaZ
echo "Step: Activate Conda Environment for SibeliaZ - Started at $(date)" >> "$log_file"
conda activate sibeliaz
echo "Step: Activate Conda Environment for SibeliaZ - Completed at $(date)" >> "$log_file"

# Define paths to the input genome FASTA files
genome1="/path/wga/genomes/celegans.fna"
genome2="/path/wga/genomes/yeast.fna"

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# Run SibeliaZ
echo "Step: Run SibeliaZ - Started at $(date)" >> "$log_file"
nohup sibeliaz -o "$output_dir" "$genome1" "$genome2" > "$script_output_log" 2>&1 &
echo "Step: Run SibeliaZ - Completed at $(date)" >> "$log_file"

# Optional: Run maf2synteny if needed
echo "Step: Run maf2synteny - Started at $(date)" >> "$log_file"
nohup maf2synteny "$output_dir/blocks_coords.gff" >> "$script_output_log" 2>&1 &
echo "Step: Run maf2synteny - Completed at $(date)" >> "$log_file"

# Deactivate the Conda environment
echo "Step: Deactivate Conda Environment - Started at $(date)" >> "$log_file"
conda deactivate
echo "Step: Deactivate Conda Environment - Completed at $(date)" >> "$log_file"

# Stop measuring the total execution time
total_end_time=$(date +%s.%N)

# Calculate and print the total execution time
total_execution_time=$(echo "$total_end_time - $total_start_time" | bc)
echo "Total Execution Time: $total_execution_time seconds" >> "$log_file"

