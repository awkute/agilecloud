
echo $(date) >> test.txt

git add test.txt
git commit -m "$(date)"
git push
