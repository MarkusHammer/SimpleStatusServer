@echo off

SET ERROR=""
SET modulename=simplestatusserver
SET targetpyver=3.12

REM NOTE THIS MUST BE BUILT USING A VERSION OF PYTHON > 3.7 and >= 3.10, 3.9.1 and 3.8.7 #THX https://github.com/pypa/build/issues/255#issuecomment-794560752
REM below are the commands used on windows, feel free to use the most up to date version of python when possible

ECHO The following expects that the current directory is the root of this repository, and that the git repo is already initialised
PAUSE

IF EXIST "./reports" RMDIR "./reports" /q /s
MKDIR "./reports"

echo _____PIP INSTALL_____
py -%targetpyver% -m pip install pipreqs validate-pyproject[all] build "twine>=6" "packaging>=25" setuptools pyright pylint flake8 || GOTO :error

echo _____VALIDATE PYPROJECT_____
py -%targetpyver% -m validate_pyproject -vv pyproject.toml -E setuptools distutils || GOTO :error

echo _____PYRIGHT_____
py -%targetpyver% -m pyright --warnings > "./reports/PYRIGHT.txt" || GOTO :error
echo _____PYLINT_____
py -%targetpyver% -m pylint -d all -e F,E,W --reports=y --output-format=text "%modulename%" > "./reports/PYLINT.txt" | GOTO :error
echo _____FLAKE8_____
py -%targetpyver% -m flake8 --count --format pylint --tee --output-file "./reports/FLAKE8.txt" || GOTO :error

echo _____PIPREQS_____
py -%targetpyver% -c "from pipreqs.pipreqs import main; main()" --mode gt --debug --force || GOTO :error

echo _____BUILD_____
py -%targetpyver% -m build -v -o "./build" || GOTO :error
echo _____BUILD CHECK_____
py -%targetpyver% -m twine check "./build/*" || GOTO :error
echo _____BUILD CLEANUP_____
echo "%modulename%.egg-info"
RMDIR "%modulename%.egg-info" /q /s || GOTO :error

echo _____GIT_____
git add -v -A || GOTO :error
git gc  --auto || GOTO :error

ECHO Also upload to pypi?
PAUSE
echo _____UPLOAD_____
py -%targetpyver% -m twine upload "./build/*" --username __token__ || GOTO :error

ECHO Complete!
GOTO :EOF

:error
ECHO Failed with error '%ERROR%' #%errorlevel%.
exit /b %errorlevel%
