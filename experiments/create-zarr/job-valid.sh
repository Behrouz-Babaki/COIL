#!/bin/bash
#SBATCH --account=rrg-bengioy-ad
#SBATCH --cpus-per-task=6  
#SBATCH --mem=8000M       
#SBATCH --time=05:00:00
#SBATCH --output=outputs/valid.out

SCRIPT_DIR=$SCRATCH/learn2price/experiments/exp21/create-zarr
DATA_DIR=$SCRATCH/learn2price/experiments/exp21/tars

echo "copying data.tar to local drive"
cp ${DATA_DIR}/data.tar $SLURM_TMPDIR

echo "extracting data.tar"
cd $SLURM_TMPDIR
tar xf data.tar

module load python/3.7

virtualenv --no-download $SLURM_TMPDIR/zarr-env
source $SLURM_TMPDIR/zarr-env/bin/activate

pip install --no-index --upgrade pip
pip install --no-index numpy
pip install --no-index numcodecs
pip install --no-index zarr
pip install --no-index networkx

echo "running the create_zarr script"
cd $SCRIPT_DIR
python create-zarr.py \
       --indir $SLURM_TMPDIR/data/valid \
       --outdir $SLURM_TMPDIR/valid.zarr \
       --num-instances 350 \
       --num-customers 21

echo "creating the tar file"
cd $SLURM_TMPDIR
tar cf valid.tar valid.zarr

echo "copying the tar file"
cd $SCRIPT_DIR
cp $SLURM_TMPDIR/valid.tar ../tars

echo "file copied successfully!"

