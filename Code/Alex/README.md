### SVR Results for Estimating theta_z

|Data Input| Kernel | C |Metric (RMSE) |
|:-|:-|:-|:-|
|M_x, thetahat_z and, log(distance sensor)| Radial Basis Function|100|12.71|
|force sensors and log(distance sensor)| Radial Basis Function|100|11.79|

### Nnet Regression Results for Estimating theta_z

|Data Input| Number of Layers |Nodes per Layer |Patience |Metric (RMSE) | Epochs |Time |
|:-|:-|:-|:-|:-|:-|:-|
|M_x, thetahat_z and, log(distance sensor) |4|200|1000|9.80|10899|40min|
|force sensors and log(distance sensor) |4|200|1000|6.60|14919|1hr|
|vec(160x120 frame) and fcss |3|50|10|4.61|180|3min|
|vec(160x120 frame) and fcss |3|50|1000|3.65|11000|6hr|
|vec(160x120 frame) and fcss |3|100|10|3.36|134|8min|
|vec(160x120 frame) and fcss |3|100|100|3.31|857|30min|
|vec(160x120 frame) and fcss |3|200|10|3.14|190|20min|
|vec(160x120 frame) and fcss |3|200|100|3.24|1800|2hr|
|vec(160x120 frame) and fcss |3|200|1000|3.39|4000|4hr|
|vec(160x120 frame) and fcss |4|50|10|4.61|180|3min|
|vec(160x120 frame) and fcss |4|50|10|3.13|215|10min|
|vec(160x120 frame) and fcss |4|100|10|**3.00**|212|10min|
|vec(160x120 frame) and fcss |4|100|100|3.07|1213|40min |
|vec(160x120 frame) and fcss |4|200|10|3.17|126|20min|
|vec(160x120 frame) and fcss |4|200|100|3.09|1015|1hr|
