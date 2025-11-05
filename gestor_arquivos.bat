@echo off
setlocal enabledelayedexpansion

:: ===========================
:: CONFIGURAÇÕES INICIAIS
:: ===========================
set "BASE=C:\GestorArquivos"
set "DOCS=%BASE%\Documentos"
set "LOGS=%BASE%\Logs"
set "BACKUPS=%BASE%\Backups"
set "LOGFILE=%LOGS%\atividade.log"
set "DATAHORA=%date% %time%"
set /a TOTAL_PASTAS=0
set /a TOTAL_ARQUIVOS=0

:: ===========================
:: FUNÇÃO PARA REGISTRAR LOG
:: ===========================
:LOG
:: %1 = Operação | %2 = Resultado
echo [%date% %time%] %1 - %2 >> "%LOGFILE%"
goto :eof


:: ===========================
:: CRIAÇÃO DE PASTAS
:: ===========================
echo Criando pastas...
for %%P in ("%BASE%" "%DOCS%" "%LOGS%" "%BACKUPS%") do (
    if exist "%%~P" (
        call :LOG "Pasta já existe: %%~P" "Sucesso"
    ) else (
        mkdir "%%~P" 2>nul
        if exist "%%~P" (
            call :LOG "Pasta criada: %%~P" "Sucesso"
            set /a TOTAL_PASTAS+=1
        ) else (
            call :LOG "Erro ao criar pasta: %%~P" "Falha"
        )
    )
)


:: ===========================
:: CRIAÇÃO E ESCRITA DE ARQUIVOS
:: ===========================
echo Criando arquivos...
(
    echo Relatório do sistema
    echo Data de geração: %date% %time%
    echo Conteúdo de exemplo
) > "%DOCS%\relatorio.txt"
if exist "%DOCS%\relatorio.txt" (
    call :LOG "Arquivo criado: relatorio.txt" "Sucesso"
    set /a TOTAL_ARQUIVOS+=1
)

(
    echo ID,Nome,Idade
    echo 1,Ana,25
    echo 2,Bruno,30
) > "%DOCS%\dados.csv"
if exist "%DOCS%\dados.csv" (
    call :LOG "Arquivo criado: dados.csv" "Sucesso"
    set /a TOTAL_ARQUIVOS+=1
)

(
    echo [GERAL]
    echo Versao=1.0
    echo Autor=Administrador
) > "%DOCS%\config.ini"
if exist "%DOCS%\config.ini" (
    call :LOG "Arquivo criado: config.ini" "Sucesso"
    set /a TOTAL_ARQUIVOS+=1
)


:: ===========================
:: SIMULAÇÃO DE BACKUP
:: ===========================
echo Fazendo backup...
xcopy "%DOCS%\*" "%BACKUPS%\" /E /I /Y >nul
if %errorlevel%==0 (
    call :LOG "Backup dos arquivos de Documentos" "Sucesso"
) else (
    call :LOG "Backup dos arquivos de Documentos" "Falha"
)

set "BACKUP_FILE=%BACKUPS%\backup_completo.bak"
echo Backup completo em %date% %time% > "%BACKUP_FILE%"
if exist "%BACKUP_FILE%" (
    call :LOG "Arquivo de backup criado: backup_completo.bak" "Sucesso"
) else (
    call :LOG "Falha ao criar arquivo de backup" "Falha"
)


:: ===========================
:: RELATÓRIO FINAL
:: ===========================
set "RELATORIO=%BASE%\resumo_execucao.txt"
(
    echo RELATÓRIO DE EXECUÇÃO
    echo ----------------------
    echo Total de arquivos criados: %TOTAL_ARQUIVOS%
    echo Total de pastas criadas: %TOTAL_PASTAS%
    echo Data/Hora do backup: %date% %time%
) > "%RELATORIO%"
call :LOG "Relatório final gerado" "Sucesso"


:: ===========================
:: FINALIZAÇÃO
:: ===========================
echo Operação concluída!
echo Veja o log em: %LOGFILE%
echo E o relatório em: %RELATORIO%
pause
exit /b
