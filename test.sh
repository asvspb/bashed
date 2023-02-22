# /bin/bash

url="https://www.oracle.com/virtualization/technologies/vm/downloads/virtualbox-downloads.html"

html_code=$(curl -s $url)

links=$(echo "$html_code" | grep -oE "href=[\"']?([^\"' >]+)" | sed -E "s/href=[\"']?//")

fedora_links=$(echo "$links" | grep -i "fedora" | grep -i "rpm")

latest_fedora_version=$(echo "$fedora_links" | sort -r | head -n1)

echo "Latest Fedora version: $latest_fedora_version"


