# sda
How to install the r-package from GitHub

```markdown
devtools::install_github("mcl868/sda", force = T)
```

## Sor codes
```markdown
lookatSHAK(x)
```
**Input**
- *x*:  Write the sor code to look up the information about the place. The character has to be a least 4 characters, see the example.

### Eksemple
```markdown
lookatSHAK("1311")
   K_SGH                     V_SGHNAVN K_FRADTO D_TILDTO C_INSTART   C_SORID      Region Institution                                               
16  1311 KØBENHAVN, BØRNEHOSPITALET PÅ 19760401 19771231       119 6.111e+12 Hovedstaden   Offentlig
17  1311 KØBENHAVN, BØRNEHOSPITALET PÅ 19780101 19831231       111 6.111e+12 Hovedstaden   Offentlig
```

## Simulate survival data
### Simulate from an addative model
```markdown
simAdditivemodel(beta1,
                 beta2,
                 unmeasured =  FALSE,
                 timevarying = FALSE,
                 samp = 1000)
```
**Input**
- *beta1*:  Models corresponding to response.
- *beta2*: The time-varying exposure.
- *unmeasured*:     Data.
- *timevarying*:     Data.
- *samp*:     Data.

### Simulate from a cox model
```markdown
simCoxmodel(beta1,
            beta2,
            beta3,
            rateC = 0.2,
            unmeasured =  FALSE,
            timevarying = FALSE,
            samp = 1000)

```
**Input**
- *beta1*:  Models corresponding to response.
- *beta2*: The time-varying exposure.
- *beta3*:     Data.
- *rateC*:     Data.
- *unmeasured*:     Data.
- *timevarying*:     Data.
- *samp*:     Data.

<h6> Updated: 2020-07-01
<a href="mailto:thomas.maltesen@proton.me">Contact me.</a>
