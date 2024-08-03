#!/bin/bash
DIR="${PWD}"
runPluginOnProject () {
    start_time=$(date +%s)
    cd $1
    echo "========= try to build the project $1"
    mvn install -DskipTests -Dspotbugs.skip=true | tee build.log
    sha=$(git rev-parse HEAD)
    mvn -Dexec.executable='echo' -Dexec.args='${project.artifactId}' exec:exec -q -fn | tee modnames
    if grep -q "[ERROR]" modnames; then
        echo "========= ERROR IN PROJECT $1"
	printf '%b\n' "$1,F,,,,,,,$(( ($(date +%s)-${start_time})/60 ))" >> ${DIR}/result.csv
        exit 1
    fi
    mkdir .runNIODetector
    mkdir ./.runNIODetector/logs
    input="modnames"
    while IFS= read -u3 -r line
    do 
	echo "========= run NIODetector in the project $1:$line"
	mvn anonymized.path:Plugin:rerun -pl :$line -Drat.skip=true -Dlicense.skip=true | tee ./.runNIODetector/logs/$line.log
	log_file=./.runNIODetector/logs/$line.log
	last_successful_line=$(grep '\[ *[0-9]* tests successful *\]' "$log_file" | tail -n 1)
	successful_tests=$(echo "$last_successful_line" | awk '{print $2}')
	last_failed_line=$(grep '\[ *[0-9]* tests failed *\]' "$log_file" | tail -n 1)
        failed_tests=$(echo "$last_failed_line" | awk '{print $2}')
	last_skipped_line=$(grep '\[ *[0-9]* tests aborted *\]' "$log_file" | tail -n 1)
        skipped_tests=$(echo "$last_skipped_line" | awk '{print $2}')
	test_count=$((successful_tests + failed_tests + skipped_tests))
	if grep -q 'Possible NIO Test(s) Found:' "$log_file"; then
		NIO_count_string=$(grep 'Possible NIO Test(s) Found' "$log_file" | tail -n 1 | awk -F ': ' '{print $2}')
		NIO_count=$((NIO_count_string))
	else
		NIO_count=0
	fi
	if [ "$NIO_count" -gt 0 ]; then
		NIO_tests=$(grep -A "$NIO_count" 'Possible NIO Test(s) Found' "$log_file" | tail -n +2 | rev | cut -d'(' -f2 | rev | awk '{print $NF}')
    		while IFS= read -r NIO_test; do
                	echo "https://$1,${sha},${line},${NIO_test}" >> ${DIR}/NIO_flaky_tests.csv
        	done <<< "$NIO_tests"
	fi
    	printf '%b\n' "$1:$line,${sha},T,${NIO_count},${test_count},${successful_tests},${failed_tests},${skipped_tests},$(( ($(date +%s)-${start_time})/60 ))" >> ${DIR}/result.csv
    done 3<"$input"
}

if [ ! "$2" ]
then
    runPluginOnProject $1
else
    for file in $1/$2/*
        do
            echo "start running NIODetector in module: $file"
            if test -d $file
            then
                runPluginOnProject.sh  $file
            fi
        done
fi
