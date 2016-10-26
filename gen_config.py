import os
import json

CONFIGS = {
    'name': {
        'evar': 'FACTORIO_SERVER_NAME',
        'default': 'Factorio Server %s' % os.environ['VERSION'],
    },
    'description': {
        'evar': 'FACTORIO_DESCRIPTION',
        'default': 'Factorio on Kubernetes',
    },
    'max_players': {
        'evar': 'FACTORIO_MAX_PLAYERS',
        'default': 0,
    },
    'visibility': {
        'evar': 'FACTORIO_VISIBILITY',
        'default': 'lan',
    },
    'username': {
        'evar': 'FACTORIO_USER_USERNAME',
        'default': '',
    },
    'password': {
        'evar': 'FACTORIO_USER_PASSWORD',
        'default': '',
    },
    'game_password': {
        'evar': 'FACTORIO_GAME_PASSWORD',
        'default': '',
    },
    'require_user_verification': {
        'evar': 'FACTORIO_REQUIRE_USER_VERIFICATION',
        'default': False,
        'type': 'bool',
    },
    'max_upload_in_kilobytes_per_second': {
        'evar': 'FACTORIO_MAX_UPLOAD_KBPS',
        'default': 0,
    },
    'ignore_player_limit_for_returning_players': {
        'evar': 'FACTORIO_IGNORE_PLAYER_LIMIT_FOR_RETURNERS',
        'default': False,
        'type': 'bool',
    },
    'allow_commands': {
        'evar': 'FACTORIO_ALLOW_COMMANDS',
        'default': 'admins-only',
    },
    'autosave_interval': {
        'evar': 'FACTORIO_AUTOSAVE_INTERVAL',
        'default': 10,
    },
    'autosave_slots': {
        'evar': 'FACTORIO_AUTOSAVE_SLOTS',
        'default': 5,
    },
    'afk_autokick_interval': {
        'evar': 'FACTORIO_AUTOKICK_INTERVAL',
        'default': 0,
    },
    'auto_pause': {
        'evar': 'FACTORIO_AUTO_PAUSE',
        'default': True,
        'type': 'bool',
    },
    'only_admins_can_pause_the_game': {
        'evar': 'FACTORIO_ONLY_ADMINS_PAUSE',
        'default': True,
        'type': 'bool',
    },
    'autosave_only_on_server': {
        'evar': 'FACTORIO_AUTOSAVE_ONLY_ON_SERVER',
        'default': True,
        'type': 'bool',
    },
    'admins': {
        'evar': 'FACTORIO_ADMINS',
        'default': '',
        'type': 'list',
    }
}


def get_and_validate_vals():
    conf = {}
    for conf_name, conf_details in CONFIGS.items():
        evar = conf_details['evar']
        default = conf_details['default']
        conf_type = conf_details.get('type', 'str')
        conf_value = os.environ.get(evar, default)

        if conf_type == 'bool' and not isinstance(conf_value, bool):
            conf_value = conf_value.strip().lower() == 'true'
        elif conf_type == 'list':
            conf_value = conf_value.split()

        conf[conf_name] = conf_value

    return conf


def dump_config_json(conf):
    print(json.dumps(conf, indent=2))


def main():
    if not 'VERSION' in os.environ:
        raise RuntimeError('A VERSION env var must be specified.')
    conf = get_and_validate_vals()
    dump_config_json(conf)


if __name__ == '__main__':
    main()
