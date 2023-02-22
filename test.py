import requests
import re

url = 'https://www.virtualbox.org/wiki/Downloads'

response = requests.get(url)
html_code = response.text

links = re.findall(r'href=[\'"]?([^\'" >]+)', html_code)

guest_additions_links = [
    link for link in links if 'Oracle_VM_VirtualBox_Extension_Pack-' in link
]

import requests
import re

url = 'https://www.oracle.com/virtualization/technologies/vm/downloads/virtualbox-downloads.html'

response = requests.get(url)
html_code = response.text

links = re.findall(r'href=[\'"]?([^\'" >]+)', html_code)

for link in links:
    if 'iso' in link:
        print(link)

print(guest_additions_links)
