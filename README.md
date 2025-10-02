# ICMS Pro App (Flutter)

App completo para consulta e cálculo de ICMS com:
- Login por PIN (definição no primeiro uso, bloqueio no próximo)
- Splash screen e ícone
- Histórico dos cálculos (com exportação CSV e compartilhamento)
- Busca por estado/UF
- Preparado para **Codemagic** (CI/CD) gerar APK automaticamente
- Pronto para Play Store (estrutura, versão, ícone e splash). Assinatura e políticas devem ser configuradas por você.

## Como gerar APK com Codemagic (upload do ZIP)
1. Acesse https://codemagic.io/start
2. Crie uma app do tipo **App using codemagic.yaml** e faça **Upload** deste ZIP.
3. Na aba **Builds**, rode o workflow **android_apk**.
4. Ao finalizar, baixe o `.apk` do artefato.

## Como rodar localmente (opcional)
```bash
flutter pub get
# gerar splash e ícones (normalmente rodado no Codemagic)
flutter pub run flutter_native_splash:create
flutter pub run flutter_launcher_icons
flutter run
```
Para gerar APK local:
```bash
flutter build apk
```

### Observação legal
As alíquotas podem variar por produto, NCM, benefício fiscal e período. Verifique normas vigentes do seu estado.
