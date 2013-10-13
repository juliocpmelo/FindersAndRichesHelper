
echo "copying files FindersAndRichesHelper.lua FindersAndRichesHelper.toc to C:\Program Files (x86)/World of Warcraft/Interface/AddOns/FindersAndRichesHelper/"

rm -rf FindersAndRichesHelper.zip
mkdir FindersAndRichesHelper
cp -r FindersAndRichesHelper.lua FindersAndRichesHelper.toc libs FindersAndRichesHelper
zip -r FindersAndRichesHelper.zip FindersAndRichesHelper
rm -rf FindersAndRichesHelper
