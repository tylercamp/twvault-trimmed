FROM mcr.microsoft.com/dotnet/core/sdk:3.1 as BUILD
COPY . /app
WORKDIR /app
RUN ["dotnet", "restore"]
RUN ["dotnet", "build"]
RUN chmod +x ./entrypoint.sh


FROM BUILD as TW.Vault.App
EXPOSE 5000/tcp
RUN apt-get update -yq && apt-get upgrade -yq && apt-get install -yq curl git nano
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && apt-get install -yq nodejs build-essential
RUN npm install -g npm
RUN npm install -g javascript-obfuscator
CMD /bin/bash ./entrypoint.sh "TW.Vault.App"


FROM BUILD as TW.Vault.Manage
EXPOSE 5030/tcp
CMD /bin/bash ./entrypoint.sh "TW.Vault.Manage"
