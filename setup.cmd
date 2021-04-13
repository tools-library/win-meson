@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION



:PROCESS_CMD
    SET "utility_folder=%~dp0"
    SET "utility_software_folder=%utility_folder%software"
    SET "utility_sfx=%utility_folder%software.exe"

    CALL "%utility_folder%..\win-utils\setup.cmd" cecho 7zip

    SET help_arg=false
    SET pack_arg=false
    SET unpack_arg=false

    SET current_arg=%1
    IF  [%current_arg%] EQU [-h]       SET help_arg=true
    IF  [%current_arg%] EQU [--help]   SET help_arg=true
    IF  [%current_arg%] EQU [--pack]   SET pack_arg=true
    IF  [%current_arg%] EQU [--unpack] SET unpack_arg=true

    IF  [%help_arg%] EQU [true] (
        CALL :SHOW_HELP
    ) ELSE (
        IF  [%pack_arg%] EQU [true]  (
            CALL :PACK
        ) ELSE (
            IF  [%unpack_arg%] EQU [true]  (
                CALL :UNPACK
            ) ELSE (
                CALL :MAIN %*
                IF !ERRORLEVEL! NEQ 0 (
                    EXIT /B !ERRORLEVEL!
                )
            )
        )
    )

    REM All changes to variables within this script, will have local scope. Only
    REM variables specified in the following block can propagates to the outside
    REM world (For example, a calling script of this script).
    ENDLOCAL & (
        SET "TOOLSET_MESON_PATH=%utility_software_folder%"
        SET "PATH=%PATH%"
    )
EXIT /B 0



:MAIN
    CALL :UNPACK

    REM Check if the 'utility_software_folder' is not already in system path. If
    REM not, insert it.
    IF "!PATH:%utility_software_folder%=!" EQU "%PATH%" (
        SET "PATH=%utility_software_folder%;%PATH%"
        CALL :SHOW_INFO "Utility added to system path."
    )
EXIT /B 0



:PACK
    IF EXIST "!utility_software_folder!" (
        CALL :SHOW_INFO "Packing utility files."
        7z u -uq0 -mx9 -sfx "!utility_sfx!" "!utility_software_folder!"
    )
EXIT /B 0

:UNPACK
    IF NOT EXIST "!utility_software_folder!" (
        CALL :SHOW_INFO "Unpacking utility files."
        CALL "!utility_sfx!" -y -o"!utility_folder!"
    )
EXIT /B 0



:SHOW_INFO
    cecho {olive}[TOOLSET - UTILS - MESON]{default} INFO: %~1{\n}
EXIT /B 0

:SHOW_ERROR
    cecho {olive}[TOOLSET - UTILS - MESON]{red} ERROR: %~1 {default} {\n}
EXIT /B 0



:SHOW_HELP
    SET "script_name=%~n0%~x0"
    ECHO #######################################################################
    ECHO #                                                                     #
    ECHO #                      T O O L   S E T U P                            #
    ECHO #                                                                     #
    ECHO #     'MESON' is an open source build system meant to be both         #
    ECHO #      extremely fast, and, even more importantly, as user            #
    ECHO #      friendly as possible.                                          #
    ECHO #                                                                     #
    ECHO #      Website https://mesonbuild.com                                 #
    ECHO #      Repository https://github.com/XNerv/meson                      #
    ECHO #                                                                     #
    ECHO #      Observation    The repository above is a fork from original    #
    ECHO #          repository https://github.com/mesonbuild/meson.            #
    ECHO #                                                                     #
    ECHO #      Attention    This is a slightly modified version, compared to  #
    ECHO #          the original. As our pull requests in the original         #
    ECHO #          repository have not yet been accepted, we will use our     #
    ECHO #          modified version. The original version on which we base    #
    ECHO #          ours is 0.55.999.                                          #
    ECHO #                                                                     #
    ECHO #       After running the %SCRIPT_NAME%, the tool will be                 #
    ECHO #       available in the system path.                                 #
    ECHO #                                                                     #
    ECHO # TOOL   : MESON                                                      #
    ECHO # VERSION: 0.55.999                                                   #
    ECHO # ARCH   : x64                                                        #
    ECHO #                                                                     #
    ECHO # USAGE:                                                              #
    ECHO #     %SCRIPT_NAME% [-h^|--help^|--pack^|--unpack]                           #
    ECHO #                                                                     #
    ECHO # EXAMPLES:                                                           #
    ECHO #     %script_name%                                                       #
    ECHO #     %script_name% -h                                                    #
    ECHO #     %script_name% --pack                                                #
    ECHO #                                                                     #
    ECHO # ARGUMENTS:                                                          #
    ECHO #     -h^|--help    Print this help and exit.                          #
    ECHO #                                                                     #
    ECHO #     --pack    Pack the content of the software folder in one        #
    ECHO #         self-extract executable called 'software.exe'.              #
    ECHO #                                                                     #
    ECHO #     --unpack    Unpack the self-extract executable 'software.exe'   #
    ECHO #         to the software folder.                                     #
    ECHO #                                                                     #
    ECHO # EXPORTED ENVIRONMENT VARIABLES:                                     #
    ECHO #     TOOLSET_MESON_PATH    Absolute path where this tool is          #
    ECHO #         located.                                                    #
    ECHO #                                                                     #
    ECHO #     PATH    This tool will export all local changes that it made to #
    ECHO #         the path's environment variable.                            #
    ECHO #                                                                     #
    ECHO #     The environment variables will be exported only if this tool    #
    ECHO #     executes without any error.                                     #
    ECHO #                                                                     #
    ECHO #######################################################################
EXIT /B 0
