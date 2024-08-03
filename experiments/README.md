# Evaluation Scripts and Results

This folder contains the scripts and results of our evaluation as described in the paper.

## Core Contents

- `projects.txt`: This file lists the slugs of all open-source projects used in our study.
- `runPluginAtScale.sh`: A script that automatically runs the plugin on the projects listed in `projects.txt`.
- `collect_NIO_information.sh`: A script that collects relevant logs after running the plugin.
- `result.csv`: This file contains the general results of the Detection Phase for all projects.
- `NIO_flaky_tests.csv`: This file contains all possible NIO tests detected across all projects.
- `autofixed_NIO_tests.csv`: This file contains all tests where our plugin successfully generated a patch.
- `patch/`: This folder stores the patches for all the tests.

## Usage

1. **Run the Plugin at Scale**:
   - To run the plugin on all projects listed in `projects.txt`, execute the following command:
     ```sh
     ./runPluginAtScale.sh projects.txt
     ```

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
  chmod +x runPluginAtScale.sh collect_NIO_information.sh

