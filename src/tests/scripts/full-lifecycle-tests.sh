#!/bin/bash
set -e -E -u -o pipefail -C

set -x

TESTREPO1=repos/testrepo1
TESTREPO2=repos/testrepo2
TESTREPO3=repos/testrepo3
PORT=
HOST=http://localhost${PORT:+:$PORT}
TESTRPM=foo-1.0-1.x86_64.rpm
CURL="curl -k"
CHECK_STATE="grep -i"

TEST_YUM=false
if yum --version &> /dev/null; then
    TEST_YUM=true
    YUM="yum -c res/yum.conf"
    echo "'yum' command found"
fi

echo "preparing test repos"
$CURL -X DELETERECURSIVLY $HOST/admin/$TESTREPO1 -s &> /dev/null
$CURL -X DELETERECURSIVLY $HOST/admin/$TESTREPO2 -s &> /dev/null
$CURL -X DELETERECURSIVLY $HOST/admin/$TESTREPO3 -s &> /dev/null


echo "check if yum-repo service is up"
$CURL $HOST/repos/           -i -s | $CHECK_STATE "200 OK"

echo "try to upload rpm to non-existant repo"
$CURL -F rpm=@res/$TESTRPM $HOST/admin/$TESTREPO1  -i -s | $CHECK_STATE "404 NOT FOUND"

echo "create $TESTREPO1"
$CURL -X PUT $HOST/admin/$TESTREPO1  -i -s
#$CURL -X PUT $HOST/admin/$TESTREPO1  -i -s | $CHECK_STATE "201 CREATED"

echo "check created repo"
$CURL $HOST/$TESTREPO1/       -i -s | $CHECK_STATE "200 OK"

echo "upload rpm to $TESTREPO1"
$CURL -F rpm=@res/$TESTRPM $HOST/admin/$TESTREPO1  -i -s | $CHECK_STATE "201 CREATED"

echo "create $TESTREPO2"
$CURL -X PUT $HOST/admin/$TESTREPO2 -i -s | $CHECK_STATE "201 CREATED"

echo "create empty repo3"
$CURL -X PUT $HOST/admin/$TESTREPO3 -i -s | $CHECK_STATE "201 CREATED"

if $TEST_YUM; then
    echo "search for rpm via yum"
    $YUM clean all
    $YUM repolist
    $YUM search foo 2> /dev/null | grep "foo.x86_64"
    echo "rpm found in repo: " $($YUM info foo | grep "testrepo1")
fi

$CURL -X STAGE $HOST/admin/$TESTREPO1/$TESTRPM/stageto/testrepo2

if $TEST_YUM; then
    echo "search for rpm via yum"
    $YUM clean all
    $YUM repolist
    $YUM search foo 2> /dev/null | grep "foo.x86_64"
    echo "rpm found in repo: " $($YUM info foo | grep "testrepo2")
fi

echo "replace repo3 with a link to repo2"
$CURL -X DELETE $HOST/admin/$TESTREPO3 -i -s | $CHECK_STATE "204 NO CONTENT"
$CURL -X PUT $HOST/admin/$TESTREPO3?link_to=testrepo2 -i -s | $CHECK_STATE "201 CREATED"

echo "check for repo links"
$CURL $HOST/admin/$TESTREPO1/is_link -i -s | grep "false"
$CURL $HOST/admin/$TESTREPO3/is_link -i -s | grep "true"

if $TEST_YUM; then
    echo "search for rpm via yum"
    $YUM clean all
    $YUM repolist
    $YUM search foo | grep "foo.x86_64"
    echo "rpm found in repo: " $($YUM info foo --showduplicates | grep "repo3")
fi

echo "tear down test repos"

echo "try to remove non-empty $TESTREPO2"
$CURL -X DELETE $HOST/admin/$TESTREPO2  -i -s | $CHECK_STATE "409 CONFLICT"

echo "remove rpm"
$CURL -X DELETE $HOST/admin/$TESTREPO2/$TESTRPM -i -s | $CHECK_STATE "204 NO CONTENT"

echo "try to remove rpm that was removed already"
$CURL -X DELETE $HOST/admin/$TESTREPO2/$TESTRPM  -i -s | $CHECK_STATE "404 NOT FOUND"

echo "remove empty repo $TESTREPO1"
$CURL -X DELETE $HOST/admin/$TESTREPO1  -i -s | $CHECK_STATE "204 NO CONTENT"

echo "remove empty repo $TESTREPO2"
$CURL -X DELETE $HOST/admin/$TESTREPO2  -i -s | $CHECK_STATE "204 NO CONTENT"

echo "SUCCESS"
