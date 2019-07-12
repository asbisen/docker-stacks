# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG BASE_CONTAINER=srv.apnet.local:5000/datascience-notebook
FROM $BASE_CONTAINER

LABEL maintainer="Anand Bisen <asbisen@icloud.com>"

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends zlib1g-dev libsz2 libstdc++6 libquadmath0 libaec0 && \
    rm -rf /var/lib/apt/lists/*

# Install Tensorflow
RUN conda install --quiet --yes \
    'tensorflow=1.13*' \
    'keras=2.2*' && \
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER


RUN julia -e 'import Pkg; Pkg.update()' && \
    julia -e 'import Pkg; Pkg.add.(["ArgParse", "CSV", "Blink", "BSON"])' && \
    julia -e 'import Pkg; Pkg.add.(["CSVFiles", "CodecZlib", "ColorBrewer", "ColorSchemes", "Colors", "Combinatorics"])' && \
    julia -e 'import Pkg; Pkg.add.(["DataFrames", "DataStructures", "Distributions", "Documenter"])' && \
    julia -e 'import Pkg; Pkg.add.(["FileIO", "Flux", "FFTW"])' && \
    julia -e 'import Pkg; Pkg.add.(["Genie", "GLPK", "GR", "GZip"])' && \
    julia -e 'import Pkg; Pkg.add.(["HTTP"])' && \
    julia -e 'import Pkg; Pkg.add.(["Images", "IJulia", "Impute", "Ipopt", "IterTools"])' && \
    julia -e 'import Pkg; Pkg.add.(["JuMP", "JuliaDB", "JSON"])' && \
    julia -e 'import Pkg; Pkg.add.(["MLDataUtils", "MLJ"])' && \
    julia -e 'import Pkg; Pkg.add.(["NodeJS"])' && \
    julia -e 'import Pkg; Pkg.add.(["OSQP", "OnlineStats"])' && \
    julia -e 'import Pkg; Pkg.add.(["Plots", "PrettyTables", "ProgressMeter", "PlotlyJS"])' && \
    julia -e 'import Pkg; Pkg.add.(["Query"])' && \
    julia -e 'import Pkg; Pkg.add.(["TableReader", "TimeSeries"])' && \
    julia -e 'import Pkg; Pkg.add.(["UnicodePlots"])' && \
    julia -e 'import Pkg; Pkg.add.(["VegaDatasets"])' && \
    julia -e 'import Pkg; Pkg.add.(["WebIO"])' && \
    julia -e 'import Pkg; Pkg.add.(["YAML"])' && \
    julia -e 'import Pkg; Pkg.add(Pkg.PackageSpec(name="Blink", rev="master"))' && \
    julia -e 'import Pkg; ENV["PYTHON"]="/opt/conda/bin/python"; Pkg.add.(["PyCall", "PyPlot", "Seaborn"]); import PyPlot' && \
    julia -e 'import Pkg; Pkg.API.precompile()' && \
    #julia -e 'import IJulia; import NodeJS; import WebIO; using Pkg; Pkg.build.(["WebIO", "IJulia", "NodeJS"])' && \
    jupyter labextension install @jupyterlab/plotly-extension && \
    #jupyter lab build && \
    jupyter-labextension unlink --debug /opt/julia/packages/WebIO/9qsL8/packages/webio && \
    chmod -R go+rx $CONDA_DIR/share/jupyter && \
    rm -rf $HOME/.local && \
    node /opt/conda/lib/python3.7/site-packages/jupyterlab/staging/yarn.js cache clean && \
    fix-permissions $JULIA_PKGDIR $CONDA_DIR/share/jupyter && \
    fix-permissions $HOME
   
