echo "iniciando o preparo do ambiente..."

# Atualizacao das dependencias
sudo apt update && sudo apt upgrade -y
sudo apt install curl gpg gcc g++ make zip plocate -y

# RVM e ruby
curl -sSL https://rvm.io/mpapis.asc | gpg --import -
curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -
\curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
sudo apt update
rvm install 3.4.4
rvm --default use 3.4.4

sudo tee /etc/profile.d/rvm.sh << 'EOF'
#
# RVM profile
#
# /etc/profile.d/rvm.sh # sh extension required for loading.
#

if
  [ -n "${BASH_VERSION:-}" -o -n "${ZSH_VERSION:-}" ] &&
  test "`\command \ps -p $$ -o ucomm=`" != dash &&
  test "`\command \ps -p $$ -o ucomm=`" != sh
then
  [[ -n "${rvm_stored_umask:-}" ]] || export rvm_stored_umask=$(umask)

  # Load user rvmrc configurations, if exist
  for file in "/etc/rvmrc" "$HOME/.rvmrc"
  do
    [[ -s "$file" ]] && source $file
  done
  if
    [[ -n "${rvm_prefix:-}" ]] &&
    [[ -s "${rvm_prefix}/.rvmrc" ]] &&
    [[ ! "$HOME/.rvmrc" -ef "${rvm_prefix}/.rvmrc" ]]
  then
    source "${rvm_prefix}/.rvmrc"
  fi

  # Load RVM if it is installed, try user then root install
  if
    [[ -s "$rvm_path/scripts/rvm" ]]
  then
    source "$rvm_path/scripts/rvm"
  elif
    [[ -s "$HOME/.rvm/scripts/rvm" ]]
  then
    true ${rvm_path:="$HOME/.rvm"}
    source "$HOME/.rvm/scripts/rvm"
  elif
    [[ -s "/usr/local/rvm/scripts/rvm" ]]
  then
    true ${rvm_path:="/usr/local/rvm"}
    source "/usr/local/rvm/scripts/rvm"
  fi

  # Add $rvm_bin_path to $PATH if necessary. Make sure this is the last PATH variable change
  if [[ -n "${rvm_bin_path}" && ! ":${PATH}:" == *":${rvm_bin_path}:"* ]]
  then PATH="${PATH}:${rvm_bin_path}"
  fi
fi
EOF

sudo chmod +x /etc/profile.d/rvm.sh && source /etc/profile.d/rvm.sh

# bundler e rails
gem install rails
gem install bundler
bundle config --global timeout 10000
bundle config --global retry 10000

# postgresql
sudo apt-get install -y postgresql libpq-dev

# Node.js
## Nota: Toda vez que for instalar o NVM verificar a versão aqui https://github.com/nvm-sh/nvm/releases
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
source ~/.bashrc
source ~/.bash_profile
nvm install --lts
nvm use node
nvm alias default node

# yarn e npm
nvm install-latest-npm
npm install -g yarn --verbose

# git
sudo apt-get install -y git-all

# Atualização da base de dados plocate
sudo updatedb

git config --global user.email ""
git config --global user.name ""

echo "Ambiente configurado!!"
