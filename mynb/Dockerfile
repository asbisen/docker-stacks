# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG BASE_CONTAINER=srv.apnet.local:5000/datascience-notebook
FROM $BASE_CONTAINER

LABEL maintainer="Anand Bisen <asbisen@icloud.com>"

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
                       zlib1g-dev              \
                       vim-tiny                \
                       libsz2 libstdc++6       \ 
                       libquadmath0            \
                       libgconf-2-4            \
                       libxtst6                \
                       libaec0              && \
    rm -rf /var/lib/apt/lists/*

# Install Tensorflow / PyTorch / XGBoost / Vaex
RUN conda install --quiet --yes opencv tqdm tk lzo urllib3 && \
    conda install --quiet --yes 'tensorflow=1.13*' 'keras=2.2*' && \
    conda install --quiet --yes pytorch-cpu torchvision-cpu -c pytorch && \
    conda install --quiet --yes matplotlib xgboost && \
    conda install --quiet --yes vaex -c conda-forge && \
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER


ENV PYTHON="/opt/conda/bin/python"
ENV CONDA_JL_HOME="/opt/conda/"
# Start by building Conda ensures it uses the 
# root environment of Anaconda which is pre-installed
RUN julia -e 'import Pkg; Pkg.add("Conda"); Pkg.build("Conda")' && \
    julia -e 'import Pkg; Pkg.update()' && \
    julia -e 'import Pkg; Pkg.add.(["ArgParse", "Arrow", "ApproxFun", "BSON", "CSV", "CSVFiles"])' && \
    julia -e 'import Pkg; Pkg.add.(["CodecZlib", "ColorBrewer", "ColorSchemes", "Colors"])'        && \
    julia -e 'import Pkg; Pkg.add.(["Combinatorics", "Clustering"])'                               && \
    julia -e 'import Pkg; Pkg.add.(["DataFrames", "DataStructures", "Distributions"])'             && \
    julia -e 'import Pkg; Pkg.add.(["Documenter", "DecisionTree"])'                                && \
    julia -e 'import Pkg; Pkg.add.(["Feather", "FileIO", "Flux", "FFTW"])'                         && \
    julia -e 'import Pkg; Pkg.add.(["Genie", "GLPK", "Glob", "GR", "GZip"])'                       && \
    julia -e 'import Pkg; Pkg.add.(["HDF5", "HTTP"])'                                              && \
    julia -e 'import Pkg; Pkg.add.(["Images", "IJulia", "Impute", "Ipopt", "IterTools"])'          && \
    julia -e 'import Pkg; Pkg.add.(["JuMP", "JuliaDB", "JSON"])'                                   && \
    julia -e 'import Pkg; Pkg.add.(["LIBSVM"])'                                                    && \
    julia -e 'import Pkg; Pkg.add.(["MLJModels", "MLDataUtils", "MLJ", "Mustache"])'               && \
    julia -e 'import Pkg; Pkg.add.(["MultivariateStats"])'                                         && \
    julia -e 'import Pkg; Pkg.add.(["NodeJS", "NaiveBayes"])'                                      && \
    julia -e 'import Pkg; Pkg.add.(["OSQP", "OnlineStats", "ORCA"])'                               && \
    julia -e 'import Pkg; Pkg.add.(["Parquet", "ParquetFiles", "Plots"])'                          && \
    julia -e 'import Pkg; Pkg.add.(["PrettyTables", "ProgressMeter", "PlotlyJS"])'                 && \
    julia -e 'import Pkg; Pkg.add.(["Query", "QuantEcon"])'                                        && \
    julia -e 'import Pkg; Pkg.add.(["StatsBase", "ScikitLearn", "StatsKit"])'                      && \
    julia -e 'import Pkg; Pkg.add.(["TableReader", "TimeSeries", "TimeseriesPrediction"])'         && \
    julia -e 'import Pkg; Pkg.add.(["UnicodePlots"])'                                              && \
    julia -e 'import Pkg; Pkg.add.(["VegaDatasets"])'                                              && \
    julia -e 'import Pkg; Pkg.add.(["Weave", "WebIO"])'                                            && \
    julia -e 'import Pkg; Pkg.add.(["XGBoost"])'                                                   && \
    julia -e 'import Pkg; Pkg.add.(["YAML"])'                                                      && \
    julia -e 'import Pkg; Pkg.add(Pkg.PackageSpec(name="Blink", rev="master"))'                    && \
    julia -e 'import Pkg; ENV["PYTHON"]="/opt/conda/bin/python"; Pkg.add.(["PyCall", "PyPlot", "Seaborn"]); import PyPlot' && \
    julia -e 'import Pkg; Pkg.API.precompile()' && \
    julia -e 'import Pkg; Pkg.gc()' && \
    jupyter labextension install @jupyterlab/plotly-extension && \
    jupyter lab build && \
    # Ensure that Jupyter does not goes in a loop of building webio && \
    #WEBIOPATH=`julia -e 'using WebIO; p=abspath(joinpath(dirname(pathof(WebIO)), "../packages/webio")); println(p)'` && \
    #jupyter-labextension unlink --debug $WEBIOPATH && \
    chmod -R go+rx $CONDA_DIR/share/jupyter && \
    rm -rf $HOME/.local && \
    # Delete all tarballs in julia repositories && \
    find /opt/julia/packages/ -type f -name "*.tar.gz" -exec rm -f {} \; && \
    # Delete CMake build source (~200MB) && \
    julia -e 'import Pkg; Pkg.add("CMake"); import CMake; pkgdir=joinpath(dirname(pathof(CMake)), "..", "deps", "downloads"); run(`rm -rf $pkgdir`)' && \
    node /opt/conda/lib/python3.7/site-packages/jupyterlab/staging/yarn.js cache clean && \
    fix-permissions $JULIA_PKGDIR $CONDA_DIR/share/jupyter && \
    fix-permissions $HOME
   
