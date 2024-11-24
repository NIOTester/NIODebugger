# Evaluation Scripts and Results

This folder contains the scripts and results of our evaluation as described in the paper.

## Core Contents

- `projects.txt`: This file lists the slugs of all open-source projects used in our study.
- `runPluginAtScale.sh`: A script that automatically runs the plugin on the projects listed in `projects.txt`. By default, the script goes through all phases with the selected LLM, using 3 runs of iterative-prompting based reflection with the addition of unsuccessful previous patches and execution results. During execution, this script calls `runPluginOnProject.sh` for each project, which uses `apply_nios.sh`, `apply_patch.sh`, and `generate_diff.py` to apply the NIODebugger-generated patch.
- `result.csv`: This file contains the general results of the Detection Phase for all projects.
- `NIO_flaky_tests.csv`: This file contains all possible NIO tests detected across all projects.
- `collect_NIO_information.sh`: A script that collects the detected NIO tests into a LaTex table.
- `autofixed_NIO_tests.csv`: This file contains all tests where our plugin successfully generated a patch using our best performing variant, NIODebugger-GPT-4.
- `{model}_patches/`: These folders stores the model-specific patches that fixes the NIO tests. The patches in `GPT4_patches/` are used for all our opened PRs. For each patched test, `{model}_patches/{module_path}/{test_name}/patch.txt` contains the output of the fixer phase, and `{model}_patches/{module_path}/{test_name}/cleaned.diff` is the produced `.diff` file used to apply the patch.

## Usage

1. **Run the Plugin at Scale**:
   - To run the plugin on all projects listed in `projects.txt`, execute the following command in a Linux environment:
     ```sh
     ./runPluginAtScale.sh projects.txt {model} {your_api_key_for_GPT}
     ```
   `{model}` can be one of `GPT4`, `GPT3.5`, `Qwen`, or `DeepSeek`. If you use non-gpt models (`Qwen` or `DeepSeek`), `{your_api_key_for_GPT}` is not needed.

2. **Collect NIO Information**:
   - After running the plugin, collect the relevant logs by executing:
     ```sh
     ./collect_NIO_information.sh
     ```

3. **Results**:
   - The `result.csv` file contains the general detection results for all projects.
   - The `NIO_flaky_tests.csv` file lists all possible NIO tests detected.
   - The `autofixed_NIO_tests.csv` file lists all tests for which the plugin successfully generated a patch.

## Notes

- Ensure that all scripts have execute permissions. You can set the permissions using:
  ```sh
  chmod +x *.sh
  ```