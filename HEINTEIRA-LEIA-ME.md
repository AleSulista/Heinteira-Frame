# Heinteira Frame — primeira base de desenvolvimento

Base oficial Drift v0.7.5, commit 02d9dc24168f9f021171f811d944a2d64b6b2209.
Marca: Heinteira Studio. Aplicativo: Heinteira Frame.

Nome, identificação macOS, título da janela, organização e ícone inicial foram adaptados. Atualização automática do Drift foi desativada para evitar oferecer o aplicativo original como atualização deste fork. Créditos e licença upstream foram preservados. A interface ainda é a upstream; a reorganização será a próxima etapa após validar esta base no Mac.

## Compilar no Mac Intel

Instale as dependências: `brew install cmake ninja qt ffmpeg zstd openssl@3 sound-touch`.
Qt precisa ser 6.10 ou superior e FFmpeg 8.x. Execute `bash scripts/build-heinteira-intel.sh` na pasta do projeto. O script compila Skia para mac-x64 e usa duas tarefas para limitar o consumo de memória. A primeira compilação do Skia pode demorar bastante.

Esta entrega contém código-fonte, não um app compilado. Não foi executada em macOS neste ambiente. Valide importação, reprodução, áudio, textos, efeitos, salvar/reabrir e exportação antes de substituir a instalação atual.

O ícone é uma proposta inicial. As personalizações internas do antigo ArnFrame não podem ser recuperadas integralmente do executável. Os projetos .drift continuam usando o formato original.
