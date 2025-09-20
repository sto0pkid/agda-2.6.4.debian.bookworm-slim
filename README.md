# agda-2.6.4.debian.bookworm-slim

`docker build -t agda-2.6.4.debian.bookworm-slim .`

`docker run --rm -v ./proofbounty/example/accepted/Goal.agda:/input/goal:ro -v ./proofbounty/example/accepted/Proof.agda:/input/proof:ro -v ./output:/output agda-2.6.4.debian.bookworm-slim proof`