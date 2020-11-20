### SVR Results for Estimating theta_z

|Data Input| Kernel | C |Metric (RMSE) |
|:-|:-|:-|:-|
|M_x, thetahat_z and, log(distance sensor)| Radial Basis Function|100|12.71|
|force sensors and log(distance sensor)| Radial Basis Function|100|11.79|

### Nnet Regression Results for Estimating theta_z

|Data Input| Number of Layers |Nodes per Layer |Patience |Metric (RMSE) | Epochs |Time | Data|
|:-|:-|:-|:-|:-|:-|:-|:-|
|M_x, thetahat_z and, log(distance sensor) |4|200|1000|9.80|10899|40min|V4/test24|
|force sensors and log(distance sensor) |4|200|1000|6.60|14919|1hr|V4/test24|
|vec(160x120 frame) and fcss |3|50|10|4.61|180|3min|V4/test24|
|vec(160x120 frame) and fcss |3|50|1000|3.65|11000|6hr|V4/test24|
|vec(160x120 frame) and fcss |3|100|10|3.36|134|8min|V4/test24|
|vec(160x120 frame) and fcss |3|100|100|3.31|857|30min|V4/test24|
|vec(160x120 frame) and fcss |3|200|10|3.14|190|20min|V4/test24|
|vec(160x120 frame) and fcss |3|200|100|3.24|1800|2hr|V4/test24|
|vec(160x120 frame) and fcss |3|200|1000|3.39|4000|4hr|V4/test24|
|vec(160x120 frame) and fcss |4|50|10|4.61|180|3min|V4/test24|
|vec(160x120 frame) and fcss |4|50|10|3.13|215|10min|V4/test24|
|vec(160x120 frame) and fcss |4|100|10|**3.00**|212|10min|V4/test24|
|vec(160x120 frame) and fcss |4|100|100|3.07|1213|40min |V4/test24|
|vec(160x120 frame) and fcss |4|200|10|3.17|126|20min|V4/test24|
|vec(160x120 frame) and fcss |4|200|100|3.09|1015|1hr|V4/test24|
|vec(160x120 frame)|4|100|10|3.47|206|10min|V5/test24|
|vec(160x120 frame)|3|100|10|3.57|206|6min|V5/test24|
|vec(160x120 frame)|3|50|10|4.07|256|5min|V5/test24|
|vec(160x120 frame)|3|200|10|3.51|144|6min|V5/test24|
|vec(160x120 frame)|3|200|100|3.79|1067|54min|V5/test24|
|vec(160x120 frame)|4|200|100|3.57|824|40min|V5/test24|
