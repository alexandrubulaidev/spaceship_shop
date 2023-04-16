const kSpaceshipId = 123;

const kSpaceship = <String, dynamic>{
  'id': kSpaceshipId,
  'name': 'Europa Voyager',
  'picture':
      'https://cdn.suwalls.com/wallpapers/fantasy/futuristic-spaceship-design-52593-1920x1080.jpg',
  'manufacturer': 'SpaceX',
  'model': 'Viva-X3-2077'
};

const kSpaceshipComponents = <Map<String, dynamic>>[
  {
    'id': 1,
    'spaceshipId': kSpaceshipId,
    'type': 'engine',
    'picture':
        'https://i.pinimg.com/736x/aa/f4/8b/aaf48b8c8ee5c350c7e8081e3f511ba8.jpg',
    'manufacturer': 'SpaceX',
    'model': 'dual-engine-2073'
  },
  {
    'id': 2,
    'spaceshipId': kSpaceshipId,
    'type': 'weapon',
    'picture':
        'https://i.pinimg.com/originals/b3/ea/3a/b3ea3a3c03009f0950d26611b57d54bd.jpg',
    'manufacturer': 'Lockhed Martin',
    'model': 'laser-batery-x23'
  },
  {
    'id': 3,
    'spaceshipId': kSpaceshipId,
    'type': 'shield',
    'manufacturer': 'Aegis Dynamics',
    'model': 'duranium-shield-generator'
  },
  {
    'id': 4,
    'spaceshipId': kSpaceshipId,
    'type': 'sensor',
    'manufacturer': 'Raytheon Technologies',
    'model': 'radar-sensor-array-5000'
  },
  {
    'id': 5,
    'spaceshipId': kSpaceshipId,
    'type': 'thruster',
    'manufacturer': 'Blue Origin',
    'model': 'ion-thruster-3'
  },
  {
    'id': 6,
    'spaceshipId': kSpaceshipId,
    'type': 'communication',
    'manufacturer': 'Boeing',
    'model': 'quantum-communication-device'
  },
  {
    'id': 7,
    'spaceshipId': kSpaceshipId,
    'type': 'navigation',
    'manufacturer': 'Northrop Grumman',
    'model': 'star-mapping-system-2'
  },
  {
    'id': 8,
    'spaceshipId': kSpaceshipId,
    'type': 'power',
    'manufacturer': 'Tesla',
    'model': 'nuclear-reactor-3'
  },
  {
    'id': 9,
    'spaceshipId': kSpaceshipId,
    'type': 'defense',
    'manufacturer': 'Lockheed Martin',
    'model': 'laser-cannon-2'
  },
];
