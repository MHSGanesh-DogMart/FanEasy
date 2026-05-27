import '../domain/models/fan_profile.dart';

/// Static seed data for the Fans deck.
///
/// Lives in the data layer so the presentation layer never imports
/// hard-coded fixtures directly. When a real backend lands, replace this
/// list with a repository fetching from `ApiService`.
const List<FanProfile> kMockFanProfiles = <FanProfile>[
  FanProfile(
    name: 'Hudson',
    age: 27,
    country: 'USA',
    flag: '🇺🇸',
    sports: ['⚽ FIFA 2026', '🏈 NFL'],
    activities: ['Watch Parties', 'Concerts'],
    matchPercent: 95,
    imageUrl:
        'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=800&auto=format',
    verified: true,
    online: true,
  ),
  FanProfile(
    name: 'Marcus',
    age: 29,
    country: 'UK',
    flag: '🇬🇧',
    sports: ['⚽ Premier League', '🏉 Rugby'],
    activities: ['Live Games', 'Sports Bars'],
    matchPercent: 88,
    imageUrl:
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800&auto=format',
    verified: true,
    online: false,
  ),
  FanProfile(
    name: 'Jaylen',
    age: 24,
    country: 'USA',
    flag: '🇺🇸',
    sports: ['🏀 NBA', '⚾ MLB'],
    activities: ['Watch Parties', 'Tailgates'],
    matchPercent: 91,
    imageUrl:
        'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=800&auto=format',
    verified: false,
    online: true,
  ),
  FanProfile(
    name: 'Carlos',
    age: 31,
    country: 'Brazil',
    flag: '🇧🇷',
    sports: ['⚽ Copa America', '🏎️ F1'],
    activities: ['Watch Parties', 'Fan Zones'],
    matchPercent: 82,
    imageUrl:
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=800&auto=format',
    verified: true,
    online: true,
  ),
  FanProfile(
    name: 'Liam',
    age: 26,
    country: 'Australia',
    flag: '🇦🇺',
    sports: ['🏏 Cricket', '🏉 AFL'],
    activities: ['Sports Bars', 'Concerts'],
    matchPercent: 79,
    imageUrl:
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=800&auto=format',
    verified: false,
    online: true,
  ),
];
