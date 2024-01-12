play_audio_alert() {
    paplay /usr/share/sounds/freedesktop/stereo/service-login.oga
}

git add . 
git commit -m "Before upgrade of packages at $(date)"
git pull 
git push
flutter upgrade
flutter pub outdated
flutter pub upgrade --major-versions

play_audio_alert