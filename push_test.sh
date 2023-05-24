VERSION="v0.3.7"
NAME="HSXCAPKit"
export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890
git add .
git commit -am "fix ${VERSION}"
git push
git tag -d ${VERSION}
git tag ${VERSION}
git push --tags

pod cache clean ${NAME} --all
pod repo push hsxorg *.podspec --use-libraries --skip-import-validation --allow-warnings --sources='https://github.com/longzl/PodSpec.git,https://github.com/CocoaPods/Specs.git'