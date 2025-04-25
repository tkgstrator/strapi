.PHONY: build
build:
	act -j deploy --eventpath .github/workflow_dispatch.json --secret-file .secrets --platform ubuntu-24.04=catthehacker/ubuntu:act-22.04