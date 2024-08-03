cat NIO_flaky_tests.csv | tail -n +2 | cut -f 5- -d / | sed 's/,[^,]*,/:/' | cut -f1 -d, | cut -f1 -d: | uniq -c | sort -nr > project_NIO_test_count.log
grep ,T, result.csv | grep -v ,error, | cut -f1,5 -d, | awk -F, '{ print $2 "," $1 }' | cut -f1 -d: | awk -F, '{ print $2 "," $1 }' | awk 'BEGIN{FS=OFS=","}{a[$1]+=$2}END{for(i in a){print i,a[i]}}' | sort -t, -k2,2 -nr > project_all_test_count.log
cat project_NIO_test_count.log | while read flaky_line; do
  cur_flaky=$(echo $flaky_line | cut -f1 -d' ')
  cur_repo=$(echo $flaky_line | cut -f2 -d' ')
  cur_total=$(grep $cur_repo counttests | cut -f2 -d,)
  SHA=$(grep $cur_repo NIO_flaky_tests.csv | cut -f2 -d, | head -1 | cut -c1-7)
  printf '%b\n' "${cur_repo} & ${SHA} & ${cur_total} & ${cur_flaky}\\\\\\" >> report_table.log
done

