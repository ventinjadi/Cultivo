# Cultivo — acesso privado

O site atual continua em `index.html`. A versão de preparação do login está em `cultivo-auth-preview.html`, e **ainda não foi publicada como página inicial**.

## Preparar a integração

1. Crie um projeto Supabase separado chamado `cultivo` (não reutilize o banco do Meu Planner).
2. Em **Authentication > Users**, crie apenas sua conta, por convite/criação administrativa no painel. Defina uma senha segura.
3. Em **Authentication > Providers > Email**, desative a criação pública de usuários (`Allow new users to sign up`).
4. Execute `cultivo-setup.sql` no SQL Editor do projeto.
5. Copie seu **User UID** em Authentication > Users e execute o INSERT de autorização ao final do SQL, substituindo o UUID de exemplo.
6. Em **Project Settings > API Keys**, copie somente a **publishable key**; em **Project Settings > Data API/API**, copie a URL do projeto. Preencha `supabase-config.js` com esses dois valores.
7. Abra `cultivo-auth-preview.html` pelo GitHub Pages (ou servidor HTTP local). Quando o login e a sincronização estiverem validados, substitua `index.html` pelo conteúdo da prévia.

## Segurança

- A URL e a chave **publishable** são públicas por design e não concedem acesso por si só. Não publique service_role/secret keys.
- Nenhuma oração pessoal deve ficar embutida no HTML público. A biblioteca e os registros devem existir apenas no campo `data` protegido por autenticação/RLS.
- RLS impede acesso de usuários não autorizados ao banco. A tela de login não é a proteção principal.
- O registro atual em localStorage **não é transferido automaticamente**. Antes de migrar, exporte Backup pelo aplicativo atual e, após o primeiro login, use Restaurar no novo app para gravar seus dados na nuvem. Não apague o arquivo de backup antes de confirmar a migração.
- Este primeiro modelo grava o estado num único documento JSON por usuário. É adequado para uso individual, mas alterações simultâneas em dois dispositivos podem sobrescrever umas às outras. Evite editar em dois aparelhos ao mesmo tempo antes de evoluirmos a sincronização.
