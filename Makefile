.PHONY: help

help:
	@echo "--------------------------------------------------------------------"
	@echo "                           Memories                                 "
	@echo "           web and mobile app for social networking                 "
	@echo "    focusing on sharing past memories with other users worldwide    "
	@echo "--------------------------------------------------------------------"
	@echo "   targets: test, pre-commit, help                                  "
	@echo "--------------------------------------------------------------------"
	@echo "    Flutter test:                                                   "
	@echo "          > make test;                                              "
	@echo "    Run pre-commit for all files:                                   "
	@echo "          > make pre-commit;                                        "
	@echo "    Help:                                                           "
	@echo "          > make;                                                   "
	@echo "          > make help;                                              "
	@echo "--------------------------------------------------------------------"

test:
ifeq ($(OS),Windows_NT)
	powershell ./hack/flutter-test.ps1
else
	./hack/flutter-test.sh
endif

pre-commit:
	@pre-commit install
	pre-commit run --all-files

git-stats:
	git log | git shortlog -sne
