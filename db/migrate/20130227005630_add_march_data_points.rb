# encoding: utf-8

class AddMarchDataPoints < ActiveRecord::Migration
  GROUP_NAME = "election-march2013"
  NOTES = "Number only (no % symbol)"

  def up
    DataPoint.create([

    # MAYOR
    {
      group_name: GROUP_NAME,
      title: "Mayor: Percent Reporting",
      data_key: "mayor_percent_reporting",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "YJ Draiman",
      data_key: "mayor_percent_DRAIMAN",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Eric Garcetti",
      data_key: "mayor_percent_GARCETTI",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Wendy Greuel",
      data_key: "mayor_percent_GREUEL",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Kevin James",
      data_key: "mayor_percent_JAMES",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Addie Miller",
      data_key: "mayor_percent_MILLER",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Jan Perry",
      data_key: "mayor_percent_PERRY",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Emanuel Pleitez",
      data_key: "mayor_percent_PLEITEZ",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Norton Sandler",
      data_key: "mayor_percent_SANDLER",
      notes: NOTES
    },


    # CITY ATTORNEY
    {
      group_name: GROUP_NAME,
      title: "City Attorney: Percent Reporting",
      data_key: "attorney_percent_reporting",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Mike Feuer",
      data_key: "attorney_percent_FEUER",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Gregory Smith",
      data_key: "attorney_percent_SMITH",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Carmen Trutanich",
      data_key: "attorney_percent_TRUTANICH",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Noel Weiss",
      data_key: "attorney_percent_WEISS",
      notes: NOTES
    },


    # CONTROLLER
    {
      group_name: GROUP_NAME,
      title: "City Controller: Percent Reporting",
      data_key: "controller_percent_reporting",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Jeff Bornstein",
      data_key: "controller_percent_BORNSTEIN",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Cary Brazeman",
      data_key: "controller_percent_BRAZEMAN",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Ron Galperin",
      data_key: "controller_percent_GALPERIN",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Analilia Joya",
      data_key: "controller_percent_JOYA",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Ankur Patel",
      data_key: "controller_percent_PATEL",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Dennis Zine",
      data_key: "controller_percent_ZINE",
      notes: NOTES
    },


    # MEASURE A
    {
      group_name: GROUP_NAME,
      title: "Measure A: Percent Reporting",
      data_key: "measureA_percent_reporting",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Yes",
      data_key: "measureA_percent_YES",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "No",
      data_key: "measureA_percent_NO",
      notes: NOTES
    },

    # LA CITY COUNCIL
    # CD1
    {
      group_name: GROUP_NAME,
      title: "City Countil CD1: Percent Reporting",
      data_key: "council_cd01_percent_reporting",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Gil Cedillo",
      data_key: "council_cd01_percent_CEDILLO",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "José Gardea",
      data_key: "council_cd01_percent_GARDEA",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Jesus Rosas",
      data_key: "council_cd01_percent_ROSAS",
      notes: NOTES
    },

    # CD3
    {
      group_name: GROUP_NAME,
      title: "City Countil CD3: Percent Reporting",
      data_key: "council_cd03_percent_reporting",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Elizabeth Badger",
      data_key: "council_cd03_percent_BADGER",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Bob Blumenfield",
      data_key: "council_cd03_percent_BLUMENFIELD",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Cary Iaccino",
      data_key: "council_cd03_percent_IACCINO",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Joyce Pearson",
      data_key: "council_cd03_percent_PEARSON",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Steven Presberg",
      data_key: "council_cd03_percent_PRESBERG",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Scott Silverstein",
      data_key: "council_cd03_percent_SILVERSTEIN",
      notes: NOTES
    },

    #CD5
    {
      group_name: GROUP_NAME,
      title: "City Countil CD5: Percent Reporting",
      data_key: "council_cd05_percent_reporting",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Mark Herd",
      data_key: "council_cd05_percent_HERD",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Paul Koretz (incumbent)",
      data_key: "council_cd05_percent_KORETZ",
      notes: NOTES
    },

    #CD7
    {
      group_name: GROUP_NAME,
      title: "City Countil CD7: Percent Reporting",
      data_key: "council_cd07_percent_reporting",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Jesse David Barron",
      data_key: "council_cd07_percent_BARRON",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Nicole Chase",
      data_key: "council_cd07_percent_CHASE",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Krystee Clark",
      data_key: "council_cd07_percent_CLARK",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Felipe Fuentes",
      data_key: "council_cd07_percent_FUENTES",
      notes: NOTES
    },

    # CD9
    {
      group_name: GROUP_NAME,
      title: "City Countil CD9: Percent Reporting",
      data_key: "council_cd09_percent_reporting",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Manuel Aldana",
      data_key: "council_cd09_percent_ALDANA",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Ana Cubas",
      data_key: "council_cd09_percent_CUBAS",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Michael Davis",
      data_key: "council_cd09_percent_DAVIS",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Ronald Gochez",
      data_key: "council_cd09_percent_GOCHEZ",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Terry Hara",
      data_key: "council_cd09_percent_HARA",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Curren Price",
      data_key: "council_cd09_percent_PRICE",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "David Roberts",
      data_key: "council_cd09_percent_ROBERTS",
      notes: NOTES
    },

    # CD11
    {
      group_name: GROUP_NAME,
      title: "City Countil CD11: Percent Reporting",
      data_key: "council_cd11_percent_reporting",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Mike Bonin",
      data_key: "council_cd11_percent_BONIN",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Odysseus Bostick",
      data_key: "council_cd11_percent_BOSTICK",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Tina Hess",
      data_key: "council_cd11_percent_HESS",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Frederick Sutton",
      data_key: "council_cd11_percent_SUTTON",
      notes: NOTES
    },

    # CD13
    {
      group_name: GROUP_NAME,
      title: "City Countil CD13: Percent Reporting",
      data_key: "council_cd13_percent_reporting",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "John Choi",
      data_key: "council_cd13_percent_CHOI",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Alexander Cruz De Ocampo",
      data_key: "council_cd13_percent_OCAMPO",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Roberto Haraldson",
      data_key: "council_cd13_percent_HARALDSON",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Sam Kbushyan",
      data_key: "council_cd13_percent_KBUSHYAN",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Emile Mack",
      data_key: "council_cd13_percent_MACK",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Robert Negrete",
      data_key: "council_cd13_percent_NEGRETE",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Mitch O’Farrell",
      data_key: "council_cd13_percent_OFARRELL",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title:  "Dr. Octavio Pescador",
      data_key: "council_cd13_percent_PESCADOR",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Josh Post",
      data_key: "council_cd13_percent_POST",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Michael Schaefer",
      data_key: "council_cd13_percent_SCHAEFER",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Jose Sigala",
      data_key: "council_cd13_percent_SIGALA",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Matt Szabo",
      data_key: "council_cd13_percent_SZABO",
      notes: NOTES
    },

    # CD15
    {
      group_name: GROUP_NAME,
      title: "City Countil CD15: Percent Reporting",
      data_key: "council_cd15_percent_reporting",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title:  "Joe Buscaino (incumbent)",
      data_key: "council_cd15_percent_BUSCAINO",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "James Law",
      data_key: "council_cd15_percent_LAW",
      notes: NOTES
    },


    # LOS ANGELES UNIFIED SCHOOL DISTRICT
    # D2
    {
      group_name: GROUP_NAME,
      title: "Unified School District D2: Percent Reporting",
      data_key: "usd_d02_percent_reporting",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Abelardo Diaz",
      data_key: "usd_d02_percent_DIAZ",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Monica Garcia (incumbent)",
      data_key: "usd_d02_percent_GARCIA",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Annamarie Montanez",
      data_key: "usd_d02_percent_MONTANEZ",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Robert Skeels",
      data_key: "usd_d02_percent_SKEELS",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Isabel Vazquez",
      data_key: "usd_d02_percent_VASQUEZ",
      notes: NOTES
    },

    # D4
    {
      group_name: GROUP_NAME,
      title: "Unified School District D4: Percent Reporting",
      data_key: "usd_d04_percent_reporting",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Kate Anderson",
      data_key: "usd_d04_percent_ANDERSON",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Steve Zimmer",
      data_key: "usd_d04_percent_ZIMMER",
      notes: NOTES
    },

    # D6
    {
      group_name: GROUP_NAME,
      title: "Unified School District D6: Percent Reporting",
      data_key: "usd_d06_percent_reporting",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Maria Cano",
      data_key: "usd_d06_percent_CANO",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Monica Ratliff",
      data_key: "usd_d06_percent_RATLIFF",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Antonio Sanchez",
      data_key: "usd_d06_percent_SANCHEZ",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Iris Zuniga",
      data_key: "usd_d06_percent_ZUNIGA",
      notes: NOTES
    },


    # TWITTER STUFF
    {
      group_name: "twitter",
      title: "Auto Tweet?",
      data_key: "auto_tweet",
      notes: "Boolean. Options: [true, false]"
    },{
      group_name: "twitter",
      title: "Twitter Tweet Append",
      data_key: "tweet_append",
      notes: "Text. This will be appended to all auto-tweets."
    }])
  end

  def down
    DataPoint.destroy_all(group_name: [GROUP_NAME, "twitter"])
  end
end
