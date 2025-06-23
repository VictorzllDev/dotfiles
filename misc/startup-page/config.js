// ╔╗ ╔═╗╔╗╔╔╦╗╔═╗
// ╠╩╗║╣ ║║║ ║ ║ ║
// ╚═╝╚═╝╝╚╝ ╩ ╚═╝
// ┌─┐┌─┐┌┐┌┌─┐┬┌─┐┬ ┬┬─┐┌─┐┌┬┐┬┌─┐┌┐┌
// │  │ ││││├┤ ││ ┬│ │├┬┘├─┤ │ ││ ││││
// └─┘└─┘┘└┘└  ┴└─┘└─┘┴└─┴ ┴ ┴ ┴└─┘┘└┘

const CONFIG = {
	// ┌┐ ┌─┐┌─┐┬┌─┐┌─┐
	// ├┴┐├─┤└─┐││  └─┐
	// └─┘┴ ┴└─┘┴└─┘└─┘

	// General
	name: "Corona",
	imageBackground: false,
	openInNewTab: true,
	twelveHourFormat: true,
	timeZone: "America/sao_paulo",

	// Greetings
	greetingMorning: "Good morning!",
	greetingAfternoon: "Good afternoon,",
	greetingEvening: "Good evening,",
	greetingNight: "Go to Sleep!",

	// Layout
	bentoLayout: "bento", // 'bento', 'lists', 'buttons'

	// Weather
	weatherKey: "8b05d62206f459e1d298cbe5844d7d87", // Write here your API Key
	weatherIcons: "OneDark", // 'Onedark', 'Nord', 'Dark', 'White'
	weatherUnit: "C", // 'F', 'C'
	language: "en", // More languages in https://openweathermap.org/current#multi

	trackLocation: true, // If false or an error occurs, the app will use the lat/lon below
	defaultLatitude: "19.593",
	defaultLongitude: "-99.250",

	// Autochange
	autoChangeTheme: false,

	// Autochange by OS
	changeThemeByOS: true,

	// Autochange by hour options (24hrs format, string must be in: hh:mm)
	changeThemeByHour: false,
	hourDarkThemeActive: "18:30",
	hourDarkThemeInactive: "07:00",

	// ┌┐ ┬ ┬┌┬┐┌┬┐┌─┐┌┐┌┌─┐
	// ├┴┐│ │ │  │ │ ││││└─┐
	// └─┘└─┘ ┴  ┴ └─┘┘└┘└─┘

	firstButtonsContainer: [
		{
			id: "1",
			name: "Github",
			icon: "github",
			link: "https://github.com/",
		},
		{
			id: "2",
			name: "Mail",
			icon: "mail",
			link: "https://mail.protonmail.com/",
		},
		{
			id: "3",
			name: "Todoist",
			icon: "trello",
			link: "https://todoist.com",
		},
		{
			id: "4",
			name: "Calendar",
			icon: "calendar",
			link: "https://calendar.google.com/calendar/r",
		},
		{
			id: "5",
			name: "Reddit",
			icon: "glasses",
			link: "https://reddit.com",
		},
		{
			id: "6",
			name: "Odysee",
			icon: "youtube",
			link: "https://odysee.com/",
		},
	],

	secondButtonsContainer: [
		{
			id: "1",
			name: "Music",
			icon: "headphones",
			link: "https://open.spotify.com",
		},
		{
			id: "2",
			name: "twitter",
			icon: "twitter",
			link: "https://twitter.com/",
		},
		{
			id: "3",
			name: "bot",
			icon: "bot",
			link: "https://discord.com/app",
		},
		{
			id: "4",
			name: "Amazon",
			icon: "shopping-bag",
			link: "https://amazon.com/",
		},
		{
			id: "5",
			name: "Hashnode",
			icon: "pen-tool",
			link: "https://hashnode.com/",
		},
		{
			id: "6",
			name: "Figma",
			icon: "figma",
			link: "https://figma.com/",
		},
	],

	// ┬  ┬┌─┐┌┬┐┌─┐
	// │  │└─┐ │ └─┐
	// ┴─┘┴└─┘ ┴ └─┘

	// First Links Container
	firstlistsContainer: [
		{
			icon: "star",
			id: "1",
			links: [
				{
					name: "z0mbi3 dots",
					link: "https://github.com/gh0stzk/dotfiles",
				},
				{
					name: "Arch Linux",
					link: "https://archlinux.org/",
				},
				{
					name: "ChatGPT",
					link: "https://chat.openai.com/",
				},
				{
					name: "MonkeyType",
					link: "https://monkeytype.com/",
				},
			],
		},
		{
			icon: "tv",
			id: "2",
			links: [
				{
					name: "YouTube",
					link: "https://www.youtube.com",
				},
				{
					name: "Netflix",
					link: "https://www.netflix.com",
				},
				{
					name: "Twitch",
					link: "https://www.twitch.tv",
				},
				{
					name: "Amazon Prime",
					link: "https://www.primevideo.com",
				},
			],
		},
	],

	// Second Links Container
	secondListsContainer: [
		{
			icon: "square-user-round",
			id: "1",
			links: [
				{
					name: "Spotify",
					link: "https://www.spotify.com",
				},
				{
					name: "r/unixporn",
					link: "https://www.reddit.com/r/unixporn",
				},
				{
					name: "Facebook",
					link: "https://www.facebook.com",
				},
				{
					name: "Twitter",
					link: "https://twitter.com",
				},
			],
		},
		{
			icon: "binary",
			id: "2",
			links: [
				{
					name: "Programming",
					link: "https://www.reddit.com/r/programming/",
				},
				{
					name: "Rust",
					link: "https://www.reddit.com/r/rust/",
				},
				{
					name: "Go",
					link: "https://www.reddit.com/r/golang/",
				},
				{
					name: "Python",
					link: "https://www.reddit.com/r/Python/",
				},
			],
		},
	],
};
