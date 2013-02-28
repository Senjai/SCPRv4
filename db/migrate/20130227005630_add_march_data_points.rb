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
      data_key: "mayor:percent_reporting",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "YJ Draiman",
      data_key: "mayor:percent_DRAIMAN",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Eric Garcetti",
      data_key: "mayor:percent_GARCETTI",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Wendy Greuel",
      data_key: "mayor:percent_GREUEL",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Kevin James",
      data_key: "mayor:percent_JAMES",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Addie Miller",
      data_key: "mayor:percent_MILLER",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Jan Perry",
      data_key: "mayor:percent_PERRY",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Emanuel Pleitez",
      data_key: "mayor:percent_PLEITEZ",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Norton Sandler",
      data_key: "mayor:percent_SANDLER",
      notes: NOTES
    },


    # CITY ATTORNEY
    {
      group_name: GROUP_NAME,
      title: "City Attorney: Percent Reporting",
      data_key: "attorney:percent_reporting",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Mike Feuer",
      data_key: "attorney:percent_FEUER",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Gregory Smith",
      data_key: "attorney:percent_SMITH",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Carmen Trutanich",
      data_key: "attorney:percent_TRUTANICH",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Noel Weiss",
      data_key: "attorney:percent_WEISS",
      notes: NOTES
    },


    # CONTROLLER
    {
      group_name: GROUP_NAME,
      title: "City Controller: Percent Reporting",
      data_key: "controller:percent_reporting",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Jeff Bornstein",
      data_key: "controller:percent_BORNSTEIN",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Cary Brazeman",
      data_key: "controller:percent_BRAZEMAN",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Ron Galperin",
      data_key: "controller:percent_GALPERIN",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Analilia Joya",
      data_key: "controller:percent_JOYA",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Ankur Patel",
      data_key: "controller:percent_PATEL",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Dennis Zine",
      data_key: "controller:percent_ZINE",
      notes: NOTES
    },


    # MEASURE A
    {
      group_name: GROUP_NAME,
      title: "Measure A: Percent Reporting",
      data_key: "measure_a:percent_reporting",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Yes",
      data_key: "measure_a:percent_YES",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "No",
      data_key: "measure_a:percent_NO",
      notes: NOTES
    },

    # LA CITY COUNCIL
    # CD1
    {
      group_name: GROUP_NAME,
      title: "City Council CD1: Percent Reporting",
      data_key: "council:cd1:percent_reporting",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Gil Cedillo",
      data_key: "council:cd1:percent_CEDILLO",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "José Gardea",
      data_key: "council:cd1:percent_GARDEA",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Jesus Rosas",
      data_key: "council:cd1:percent_ROSAS",
      notes: NOTES
    },

    # CD3
    {
      group_name: GROUP_NAME,
      title: "City Council CD3: Percent Reporting",
      data_key: "council:cd3:percent_reporting",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Elizabeth Badger",
      data_key: "council:cd3:percent_BADGER",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Bob Blumenfield",
      data_key: "council:cd3:percent_BLUMENFIELD",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Cary Iaccino",
      data_key: "council:cd3:percent_IACCINO",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Joyce Pearson",
      data_key: "council:cd3:percent_PEARSON",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Steven Presberg",
      data_key: "council:cd3:percent_PRESBERG",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Scott Silverstein",
      data_key: "council:cd3:percent_SILVERSTEIN",
      notes: NOTES
    },

    #CD5
    {
      group_name: GROUP_NAME,
      title: "City Council CD5: Percent Reporting",
      data_key: "council:cd5:percent_reporting",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Mark Herd",
      data_key: "council:cd5:percent_HERD",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Paul Koretz (incumbent)",
      data_key: "council:cd5:percent_KORETZ",
      notes: NOTES
    },

    #CD7
    {
      group_name: GROUP_NAME,
      title: "City Council CD7: Percent Reporting",
      data_key: "council:cd7:percent_reporting",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Jesse David Barron",
      data_key: "council:cd7:percent_BARRON",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Nicole Chase",
      data_key: "council:cd7:percent_CHASE",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Krystee Clark",
      data_key: "council:cd7:percent_CLARK",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Felipe Fuentes",
      data_key: "council:cd7:percent_FUENTES",
      notes: NOTES
    },

    # CD9
    {
      group_name: GROUP_NAME,
      title: "City Council CD9: Percent Reporting",
      data_key: "council:cd9:percent_reporting",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Manuel Aldana",
      data_key: "council:cd9:percent_ALDANA",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Ana Cubas",
      data_key: "council:cd9:percent_CUBAS",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Michael Davis",
      data_key: "council:cd9:percent_DAVIS",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Ronald Gochez",
      data_key: "council:cd9:percent_GOCHEZ",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Terry Hara",
      data_key: "council:cd9:percent_HARA",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Curren Price",
      data_key: "council:cd9:percent_PRICE",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "David Roberts",
      data_key: "council:cd9:percent_ROBERTS",
      notes: NOTES
    },

    # CD11
    {
      group_name: GROUP_NAME,
      title: "City Council CD11: Percent Reporting",
      data_key: "council:cd11:percent_reporting",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Mike Bonin",
      data_key: "council:cd11:percent_BONIN",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Odysseus Bostick",
      data_key: "council:cd11:percent_BOSTICK",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Tina Hess",
      data_key: "council:cd11:percent_HESS",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Frederick Sutton",
      data_key: "council:cd11:percent_SUTTON",
      notes: NOTES
    },

    # CD13
    {
      group_name: GROUP_NAME,
      title: "City Council CD13: Percent Reporting",
      data_key: "council:cd13:percent_reporting",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "John Choi",
      data_key: "council:cd13:percent_CHOI",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Alexander Cruz De Ocampo",
      data_key: "council:cd13:percent_OCAMPO",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Roberto Haraldson",
      data_key: "council:cd13:percent_HARALDSON",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Sam Kbushyan",
      data_key: "council:cd13:percent_KBUSHYAN",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Emile Mack",
      data_key: "council:cd13:percent_MACK",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Robert Negrete",
      data_key: "council:cd13:percent_NEGRETE",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Mitch O’Farrell",
      data_key: "council:cd13:percent_OFARRELL",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title:  "Dr. Octavio Pescador",
      data_key: "council:cd13:percent_PESCADOR",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Josh Post",
      data_key: "council:cd13:percent_POST",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Michael Schaefer",
      data_key: "council:cd13:percent_SCHAEFER",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Jose Sigala",
      data_key: "council:cd13:percent_SIGALA",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Matt Szabo",
      data_key: "council:cd13:percent_SZABO",
      notes: NOTES
    },

    # CD15
    {
      group_name: GROUP_NAME,
      title: "City Council CD15: Percent Reporting",
      data_key: "council:cd15:percent_reporting",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title:  "Joe Buscaino (incumbent)",
      data_key: "council:cd15:percent_BUSCAINO",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "James Law",
      data_key: "council:cd15:percent_LAW",
      notes: NOTES
    },


    # LOS ANGELES UNIFIED SCHOOL DISTRICT
    # D2
    {
      group_name: GROUP_NAME,
      title: "LAUSD D2: Percent Reporting",
      data_key: "lausd:d2:percent_reporting",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Abelardo Diaz",
      data_key: "lausd:d2:percent_DIAZ",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Monica Garcia (incumbent)",
      data_key: "lausd:d2:percent_GARCIA",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Annamarie Montanez",
      data_key: "lausd:d2:percent_MONTANEZ",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Robert Skeels",
      data_key: "lausd:d2:percent_SKEELS",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Isabel Vazquez",
      data_key: "lausd:d2:percent_VASQUEZ",
      notes: NOTES
    },

    # D4
    {
      group_name: GROUP_NAME,
      title: "LAUSD D4: Percent Reporting",
      data_key: "lausd:d4:percent_reporting",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Kate Anderson",
      data_key: "lausd:d4:percent_ANDERSON",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Steve Zimmer",
      data_key: "lausd:d4:percent_ZIMMER",
      notes: NOTES
    },

    # D6
    {
      group_name: GROUP_NAME,
      title: "LAUSD D6: Percent Reporting",
      data_key: "lausd:d6:percent_reporting",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Maria Cano",
      data_key: "lausd:d6:percent_CANO",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Monica Ratliff",
      data_key: "lausd:d6:percent_RATLIFF",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Antonio Sanchez",
      data_key: "lausd:d6:percent_SANCHEZ",
      notes: NOTES
    },{
      group_name: GROUP_NAME,
      title: "Iris Zuniga",
      data_key: "lausd:d6:percent_ZUNIGA",
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
