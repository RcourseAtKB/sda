# sdatry
How to install the r-package from GitHub

```markdown
devtools::install_github("mcl868/sdatry", force = T)
```

## Sor codes
```markdown
lookatSHAK(x)
```
**Input**
- *x*:  Models corresponding to response.

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
