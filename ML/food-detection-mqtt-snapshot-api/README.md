# Food-Detector-Meraki-Snapshot-API-MQTT

## A completely customizable Object Detection tool for Meraki camera using Snapshot API with MQTT capabilities.

1. Install pipenv

```
pip install pipenv
```

2. In the root directory,

```
pipenv install
```

to install the packages and then to use an environment(shell)

```
pipenv shell
```

3. Create a classes.json file inside model_dir folder with it's key as your model's prediction id and value as class name.

```
{"1": "egg", "2": "roti", "3": "rice", "4": "side_dish"}
``` 

Here, if the model predicts 1, then egg is the class.

4. Place your very own custom Tensorflow SavedModel folder in model_dir folder. For example, after placing classes.json

```
model_dir
└── classes.json
└── saved_model
    ├── assets
    ├── saved_model.pb
    └── variables
        ├── variables.data-....
        ├── variables.data-....
        └── variables.index
``` 

5. Edit configurations in config.ini file.

* In credential section, enter meraki camera credentials
* In model section, enter saved model folder name. In the above example, model_dir = model_dir/saved_model
* In mqtt section, enter broker and topic details

6. Run 

```
food_detector.py
```

NOTE: To view what food_detector.py published, run ```subsrciber.py```
