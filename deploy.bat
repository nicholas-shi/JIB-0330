if %1 == prod goto prod
	rem call xcopy /y firebase_config\Dockerfile_dev server\Dockerfile
	rem call cd server
	rem call gcloud config set project ga-knowledge-hub-dev
	rem call gcloud builds submit --tag gcr.io/ga-knowledge-hub-dev/knowledge-hub-dev
	rem call gcloud beta run deploy knowledge-hub-dev --image gcr.io/ga-knowledge-hub-dev/knowledge-hub-dev --platform managed
	rem call cd ..
	rem call xcopy /y firebase_config\firebase_dev.json firebase.json
	FOR /F "tokens=5 delims= " %%P IN ('netstat -ano ^| findstr /r "TCP[ ]*127\.0\.0\.1:8081"') DO TaskKill.exe /F /PID %%P
	call node_modules\.bin\firebase emulators:start --import=local_test_data
	exit /b
:prod
	call cd server
	call gcloud builds submit --tag gcr.io/ga-knowledge-hub/knowledge-hub
	call gcloud beta run deploy knowledge-hub --image gcr.io/ga-knowledge-hub/knowledge-hub --platform managed
	call cd ..
	rem call xcopy /y firebase_config\firebase_prod.json firebase.json
	call node_modules\.bin\firebase deploy --only hosting