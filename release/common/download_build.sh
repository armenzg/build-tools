pushd `dirname $0` &>/dev/null
MY_DIR=$(pwd)
popd &>/dev/null
retry="$MY_DIR/../../buildfarm/utils/retry.py -s 1 -r 3"


download_build() {
  url="$1"

  if [ -z "$url" ]
  then
    "download_build usage: <url>"
    exit 1
  fi

  source_file=`basename "$url"`
  if [ -f "$source_file" ]; then rm "$source_file"; fi
  cd downloads
  if [ -f "$source_file" ]; then rm "$source_file"; fi
  cached_download "${source_file}" "${url}"
  status=$?
  if [ $status != 0 ]; then
    echo "FAIL: Could not download source $source_file from $url"
    echo "skipping.."
    cd ../
    return $status
  fi
  cd ../
}
