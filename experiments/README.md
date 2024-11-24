# Evaluation Scripts and Results

This folder contains the scripts and results of our evaluation as described in the paper.

## Core Contents

- `projects.txt`: This file lists the slugs of all open-source projects used in our study.
- `runPluginAtScale.sh`: A script that automatically runs the plugin on the projects listed in `projects.txt`. By default, the script uses GPT-4, and allows 3 runs of iterative prompting with the use of unsuccessful previous patches and execution results. During execution, this script calls `runPluginOnProject.sh` for each project, which uses `apply_nios.sh`, `apply_patch.sh`, and `generate_diff.py` to apply the NIODebugger-generated patch.
- `result.csv`: This file contains the general results of the Detection Phase for all projects.
- `NIO_flaky_tests.csv`: This file contains all possible NIO tests detected across all projects.
- `collect_NIO_information.sh`: A script that collects the detected NIO tests into a LaTex table.
- `autofixed_NIO_tests.csv`: This file contains all tests where our plugin successfully generated a patch using GPT-4.
- `patch/`: This folder stores the GPT-4 patches generated for all detected tests, which are used for all opened PRs.

## Usage

1. **Run the Plugin at Scale**:
   - To run the plugin on all projects listed in `projects.txt`, execute the following command:
     ```sh
     ./runPluginAtScale.sh projects.txt {model} {your_api_key_for_GPT}
     ```
   `{model}` can be one of `GPT4`, `GPT3.5`, `Qwen`, or `DeepSeek`. If you use non-gpt models, `{your_api_key_for_GPT}` is not needed.

2. **Collect NIO Information**:
   - After running the plugin, collect the relevant logs by executing:
     ```sh
     ./collect_NIO_information.sh
     ```

3. **Results**:
   - The `result.csv` file will contain the general detection results for all projects.
   - The `NIO_flaky_tests.csv` file will list all possible NIO tests detected.
   - The `autofixed_NIO_tests.csv` file will list all tests for which the plugin successfully generated a patch.
   - The `patch/` folder will contain the generated patches for all tests.

## Notes

- Ensure that all scripts have execute permissions. You can set the permissions using:
  ```sh
  chmod +x *.sh
