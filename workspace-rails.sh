echo "iniciando o preparo do ambiente..."

# Atualizacao das dependencias
sudo apt update
sudo apt upgrade -y
sudo apt install curl gpg gcc g++ make -y
sudo apt-get install -y zip mlocate

# RVM e ruby
gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
\curl -sSL https://rvm.io/mpapis.asc | gpg --import -
\curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -
\curl -sSL https://get.rvm.io | bash -s stable
echo 'source "$HOME/.rvm/scripts/rvm"' >> ~/.bashrc
source ~/.bashrc
rvm get stable
# Obter a última versão LTS do Ruby
LATEST_LTS=$(rvm list known | grep -E '\[ruby-[0-9]+\.[0-9]+\.[0-9]+\]' | grep -v 'preview\|rc' | tail -n 1 | awk '{print $1}' | tr -d '[]')
# Usar a última versão LTS do Ruby como padrão
rvm use --default --install $LATEST_LTS

# bundler e rails
gem install bundler
gem install rails

# postgresql
sudo apt-get install -y postgresql libpq-dev

# Node.js
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
source ~/.bashrc
source ~/.bash_profile
nvm install --lts
nvm use --lts
nvm alias default node

# yarn 
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update -y
sudo apt-get install -y yarn

# git
sudo apt-get install -y git-all

git config --global user.email ""
git config --global user.name ""

echo "Ambiente configurado!!"
