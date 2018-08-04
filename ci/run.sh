#!/bin/sh

set -e

if [ "x${FUNCTIONAL}" == "x" ];
then
	echo "Skipping functional tests"
	exit 0;
fi

root_dir="$(pwd)"
puppet_code="class { ::hosts: hosts => [{'ip'=>'127.0.0.100', 'aliases'=>'local-test'}], target => '${root_dir}/hosts.txt' }"

echo "Will run: '${puppet_code}'"

bundle exec puppet apply --test --modulepath="${root_dir}/spec/fixtures/modules" -e "${puppet_code}"

lines=$(cat hosts.txt | grep '127.0.0.100\s\+local-test' | wc -l)

test $lines -eq 1
