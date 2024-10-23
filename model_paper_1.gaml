 /**
* Name: Vector Host Model
* Based on the internal empty template. 
* Author: Cyrine Chenaoui 
* Tags: 
*/
model vectorhost
global torus: false{  //par défaut il est false 

/************************************************************************************************************************************ */
/*******************************************HOST related gobal parameters*************************************************** */
/*********************************************************************************************************************************** */
/************************************************************************************************************************************* */
/******************************Global parameters used  by  species host*********************************************/
	
	 float parasite_max ; 
	point HERD_LOC <- {500#m,500#m}; 
	int INI_NUM_HOST <- INI_NUM_RODENT+ INI_NUM_CATTLE; // initial number of hosts

	//initial number of livestock 
	int INI_NUM_CATTLE;
	//initial number of rodents
	int INI_NUM_RODENT; //<-20 min: 1 max: 10000 parameter:'Initial number of rodents' category: "Host"; 
	//environment  HERD_LOC;
	float MIN_H_SPEED<- 0.02 #km/#h parameter:"Minimum Host speed" category:"Host";
	float MAX_H_SPEED<-0.5 #km/#h parameter: "Maximum Host speed" category:"Host"; 
	float START_ACTIVE_TIME<-9.0 #hour parameter: "Start active hour"  category: "Host";
	float END_ACTIVE_TIME<-16.0 #hour parameter: "end active hour" category: "Host";
//Variables for the movement of the boids
	float minimal_distance <- 50.0 #m; 
	 cattle leader;
	 
/*********************************************************************************************************************************
 * *****************************************************************************************************************************
 *********************************VECTOR related global parameters**************************************************
 ******************************************************************************************************************************
 *****************************************************************************************************************************
  */
/******************************Global parameters used by   species vector*********************************************/

	
	//float OptimalTempMin_ovi <-22.0 parameter:"OptimalTempMin_ovi" category:"Vector" ;// optimal temperature for oviposition
//	float OptimalTempMax_ovi<-25.0 parameter:"OptimalTempMax_ovi" category:"Vector";
	//test 1 
	//float OptimalTempMin <-15.0 parameter:"OptimalTempMin" category:"Vector"; // optimal temperature for incubation, moulting 
//	float OptimalTempMax<-25.0 parameter:"OptimalTempMax" category:"Vector";  // optimal tempreture for incubation , moulting 
	float OptimalTempMin_ovi <-0.0;// parameter:"OptimalTempMin_ovi" category:"Vector" ;// optimal temperature for oviposition
	float OptimalTempMax_ovi<-30.0 ;
	//test 1 
	float OptimalTempMin <-0.0 ; //moulting 
	float OptimalTempMax<-30.0;//moulting
	float OptimalTempMin_inc <-0.0 ;
	float OptimalTempMax_inc<-30.0;
	
	float MIN_V_SPEED <- 1 #m/#h parameter:"Minimum Vector speed" category:"Vector";

	float MAX_V_SPEED<- 5 #m/#h parameter: "Maximum Vector speed" category:"Vector";
	
	//int INI_NUM_VECTOR;
    int INI_NUM_VECTOR; //initial number of  vectors
	float PERCEPTION_DISTANCE;
	
	int LETHAL_TEMP_SUP_L ;
	int LETHAL_TEMP_SUP_N  ;
	int LETHAL_TEMP_SUP_E;
	int LETHAL_TEMP_SUP_A;
	int LETHAL_TEMP_INF_N;
	int LETHAL_TEMP_INF_A;
	int LETHAL_TEMP_INF_L ;
	int LETHAL_TEMP_INF_E; 	
	float  THRESHOLD_T_L;
	float THRESHOLD_T_N;
	float THRESHOLD_T_A; 
    float THRESHOLD_T_E; 
	float ProbToLay; //<-0.5 parameter: "Probability to lay" min:0.0 max:1.0 category:"Vector"; //probability to lay egg ( only for adult) 
	 float fecundity ;
	float P_ATTACH; 
	float P_NAT_MOR_N;
    float P_NAT_MOR_L; 
     float P_NAT_MOR_E; 
    float P_NAT_MOR_A ;
     //float P_DIE;
   // int TimeDieAttach ; //Time to die when attached 
	int AttachToDetach; // Duration of attachment until detachment 
	int DetachToMoultLarva ; //Duration of detachment until moulting for larva 
	int DetachToMoultNymph; //Duration of detachment until moulting for nymph 
	//int DetachToPreovi; //Duration of detachment until preoviposition ( only for Adult, equivalent to DetachToMoult in larva ana nymph)
	//int PreoviToOvi; //Duration of oviposition  (only for adult) 
//	int LaidToIncubation; //Duration of incubation (only  for egg) 
   bool HostSeeking;
   float TimeDieQuesting ; //Time  to die when questing ( if not attached)
	//outputs 
	int TotalDeadLarva; 
    int TotalDeadAdult; 
    int TotalDeadNymph; 
    int TotalDeadEgg; 
 /*********************************************************************************Acaricides application************************************************************************* */   
       bool TCS; 
        float P_ACAR;
           int TotalAcaricdesNymph;
          int TotalAcaricdesLarva;
	/******************************Global parameters used  by species  Environment *********************************************/
    geometry shape<-square(1 #km); //taille du monde  
	csv_file MY_FILE_TUNISIA <- csv_file("../includes/reel_wisconsin_00_01.csv",false);
	//file MY_FILE_TUNISIA <- csv_file("../includes/temp_wisconsin_90.csv");
    matrix MatrixT <-matrix(MY_FILE_TUNISIA); // the file is placed as a matrix 
    list<float> TEMP_TUNISIA<- MatrixT column_at 1; // matrix containing rTEMP_TUNISIA column 
    list datee<- MatrixT column_at 0;
    float INI_TEMP<-TEMP_TUNISIA[0]; //initial TEMP_TUNISIA 
   
    float CurrentTemp; // current TEMP_TUNISIA 
    
	date starting_date<- date("1990-10-1");
	//def variables
  
    int j<- 0;   // compteur 
     float ALPHA<-0.2;
    

	/****************************************************************************************************************************************************************
	 * **********************************************Global parameters*******************************************************  */
	float  TIMESTEP_DAY <- 1 #day ; 
	
	int num_sim ;
	int the_seed; 
	
	 int id; 
	float step <- 1 #hour ;
    /**************************************************************************Functions*************************************************************************** 
     * ***************************************************************************************************************************************************************/
    
    /****************************************************Environmental mortality******************************************************************************** */
   //float function_env(float)
   
   
     float function(float lethal_temp_sup , float lethal_temp_inf , float current_t) {
	if current_t>=lethal_temp_sup {
		//write "hi";
		 	//float p_env<-ALPHA*((current_t-lethal_temp_sup )/MAX_TEMP)^(0.1) with_precision 2; 
		 	float p_env<-0.5; 
		return p_env;
		//write p_env;
		 	}
		 if current_t< lethal_temp_inf { //revoir les valeurs des  temp limites 
		// float 	p_env<-ALPHA*((current_t-lethal_temp_inf)/MIN_TEMP )^(0.2) with_precision 2;
				 	float p_env<-0.5; 
		
		return p_env ;
		
	}
	}
	/*************************************************************************************************************************************************************** */
	/*******************************************Preoviposition & Incubation********************************************************************************* */
	/*************************************************************************************************************************************************************** */
	bool test;
	float test_incub;	
	
		float preovi;
	//bool ovipos <- false; 
	 /******************************************************************************************** */
	 bool function_test(  float comp){
	 	test<-false;
	 	if comp>=1   {
			     	test<- true;
			     }
	return test;
	 }
	
	int function_IncubationDuration ( float cur_t, float opt_t_min, float opt_t_max){
	// ffaire une fct de ditance euclidienne selon la temperature optimale,  
	if (cur_t>= opt_t_min) and  (cur_t<= opt_t_max){ 
		test_incub<- 34600*CurrentTemp^(-2.35);  
	}

	return int(test_incub); 
	}
/****************************************************************************************************** */
/*************************************************************************************************** */
	 float function_Preoviposition(float cur_t, float opt_t_min, float opt_t_max){
	 
	 	if (cur_t>=  opt_t_min) and  (cur_t<= opt_t_max){ 
			     //preovi<-1200*cur_t^(-1.45) ; //for smoothed 
			      preovi<-1200*cur_t^(-1.3) ; // for real temp 
			     }
	return preovi; 
	 }	
/******************************************************************************************************* */	
	 /********************Premoult function for larva & nymph */
/*************************************************************************************************** */ 
	float premoult; 
	 float function_premoult_larva(float cur_t, float opt_t_min, float opt_t_max){
	 
	 	if (cur_t>=  opt_t_min) and  (cur_t<= opt_t_max){ 
			     premoult<-101181*cur_t^(-2.9) ;
			     
			     }
	return premoult; 
	 }
	  float function_premoult_nymph(float cur_t, float opt_t_min, float opt_t_max){
	 
	 	if (cur_t>=  opt_t_min) and  (cur_t<= opt_t_max){ 
			 //  premoult<-1596*cur_t^(-1.13) ; // nymph smoothed 
			    premoult<-1300*cur_t^(-1.23) ; // nymph real  // à 20 C 32 jours 
			       // premoult<-101181*cur_t^(-2.55) ; //larv	 
			     }
	return premoult; 
	
	}
/***************************************************************************************************** */	 

	
float start_time;
	/*************************************************Initialization***************************************************** */
	init {
		// write INI_TEMP ; 
		  int NB_ADULT_INIT <-INI_NUM_VECTOR;
            create vector number: NB_ADULT_INIT {  //premier cohorte de la première génération
         
           self.state<-'adult';
		  
            }
		create cattle number: INI_NUM_CATTLE  {
			self.myspeed<-  rnd(MIN_H_SPEED,MAX_H_SPEED) with_precision 2;	
			self.location<-{500#m,500#m};
		}	
		leader<- one_of(cattle);  
		leader.color_host<-#pink;
		leader.size_host<- 5#m;
	    create rodent number: INI_NUM_RODENT {
	    	self.myspeed<-  rnd(MIN_H_SPEED,MAX_H_SPEED) with_precision 2;	
	    		self.location<- any_point_in(shape);
	    } 
	    
	   create etable {
        	shape <- polygon([{450#m,450#m}, {450#m,550 #m}, {550#m,550#m}, {550#m,450#m}]) ; 
        
        }

	}
    reflex SetEnvCdt when :every(1#day) /*since(starting_date) */{
    	 	CurrentTemp<-TEMP_TUNISIA[j];
    	 	j<-j+1;	
    }
reflex stop_simulation when:  after(starting_date plus_years 10) {
    	write "Congrats ! you made it!";
    	write current_date; 
    	write " pop adundance" + " " + length(vector);
    	write  "total duration   " + total_duration  ;
		do pause() ;	
	}
reflex error_simulation_exticnt when: length(vector)=0 {
		
	write "vector population go extinct " ;
	write " current temperature " + "  "  + CurrentTemp;
		do pause(); 	
	}

reflex error_simulation_expon when: length(vector)=100000 {	
	write "vector population go extinct " ;
	write " current temperature " + "  "  + CurrentTemp;
//	write" current-date" + " " + current_date;
		do pause(); 
		
		
	}
/****************************************************Saving outputs************************************************************* */
 //save [DetachToMoultLarva,DetachToMoultNymph,THRESHOLD_T_L,THRESHOLD_T_N,ProbToLay]to: "../results/lifestate_multi_10/lifestate_parameters_"+"_"+seed+ ".csv" type:"csv" rewrite: false;
reflex parm_pop_dynamics when:every(#day){
			save [current_date,CurrentTemp,THRESHOLD_T_L, THRESHOLD_T_A,THRESHOLD_T_E,THRESHOLD_T_N, P_NAT_MOR_N,  P_NAT_MOR_L, 
				P_NAT_MOR_E, seed, ProbToLay,vector count(each.state="egg"),vector count(each.state="egg" and each.Diapause),vector count(each.state="larva"), 
				vector count(each.state="larva" and each.BehState="q"), vector count(each.state="larva" and each.BehState="f"),vector count(each.state="larva" and each.BehState="m"),
				vector count(each.state="larva" and each.Diapause),vector count(each.state="nymph"),vector count(each.state="nymph" and each.BehState="q"),
				vector count(each.state="nymph" and each.BehState="f"),vector count(each.state="nymph" and each.BehState="m"), 
				vector count(each.state="nymph" and each.Diapause),vector count(each.state="adult"),vector count(each.state="adult" and each.BehState="q"),
				vector count(each.state="adult" and each.BehState="f"),vector count(each.state="adult" and each.Diapause),TotalDeadLarva,TotalDeadEgg,
				TotalDeadNymph, TotalDeadAdult,length(vector),total_duration
				
			] to: "../results/lifestate/lifestate_path_real_carr//lifestate_path_real_carr"+id+"_"+seed+"_"+parasite_max+ ".csv" format:"csv" rewrite: false;
			}

}
/***************************************************VECTOR************************************************ */
species vector skills:[moving] control:fsm{
	
	//int age ; //age of the vector added to imply the two years life cycle 
	 bool killme<- false; // variable de controle pour les adules qui ne vont pas pondre , vont mourrir de toute les façons 
	 float compteur;
	 string rng<- "cellular";
	 
	  int MoultingDuration ; 
	  float  PreoviToOvi  ; //Duration of oviposition  (only for adult) 
      bool oviposition <-false ;
	  float  LaidToIncubation ; //Duration of incubation (only  for egg)  larval hatching in kocan 2015
	  bool incubation<- false;   
	   bool moulted; 
	   date EntDiapause;

   
	/**********************visualization***********************/
             rgb color_vector; 
             float size_vector<- 0.1; //1.0; 	
             aspect base_vector {
             draw sphere(size_vector*20) color:color_vector ; 
             draw BehState color:#black;
              if self.state='egg'{
            	   self.color_vector<- #yellow; 
            }
            if self.state='larva'{
            	//draw icon2 size: size_vector;
            	self.color_vector<-#green;
            }
            if self.state="nymph"{
            	//draw icon3 size: size_vector;
            	self.color_vector<- #blue;
            }
            if self.state="adult"{
            	//draw icon3 size:3;
            	self.color_vector<- #red;
            }
           
           }
/******************************ecology**************************/

string PrevBehState; 
Host TargetHost;

bool Laid<- false;
string BehState; // q: questing; f: feeding; m: moulting 

string BehStateBeforeDia; 
 
date AttachDetachDate; 
date LayDate; 
date QuestDate; 
//date transitiondate;

list<Host> NeighHosts; //liste des hotes dans la distance de perception when is BehState="f"  

bool LayingEgg;  // denotes the fitness of adult to lay eggs 
bool Diapause; //true when the individual is in Diapause 

init{
	self.TargetHost <- nil;
	self.NeighHosts<-[];
	self.Diapause<- false;
	
	//self.oviposition <-false;
	self.moulted<-false;
	
}     
state egg initial:true {
	enter {	
   self.color_vector<- #yellow; 
   self.compteur<-0.0;
    if self.Diapause=true { //juste pour l'état initial
		self.incubation<- true; 
		self.LayDate<- current_date; 
		self.EntDiapause<-current_date;
		
	}
	else {
	self.EntDiapause<-nil;
	self.incubation<- false; 
	self.oviposition <-false;
	self.LayDate<- current_date; 
	}
   }
transition to: larva when:  self.Diapause= false and self.incubation=true {
	//write current_date; 
	self.LayDate<- nil;
	self.compteur<-0.0;
}

}
state larva{
	enter{
		self. EntDiapause<-nil;
		//self.age<- 0 ; //only for larva because larva should overwinter , in days 
		self.compteur<-0.0;
		self.incubation<- false ; 
		self.oviposition <-false;
		self.moulted<-false;
	    self. EntDiapause<-nil; //date d'ntrée en diapause 
	    self.MoultingDuration<-0;
     	self.AttachDetachDate<-nil;
     	self.BehStateBeforeDia<- nil; 
     	   if self.PrevBehState="m" {// pour l'état initial ( sinon il y aura un conflit dans diapause 
     	self.BehState<-"m"; // je l'ai changé en moulting car les nymphes en hiver sont en fin du cycle 
    	self.QuestDate<-current_date;
    	 self.compteur<-0.0;
     }
     	else {
     		self.BehState<-"q";
     		self.QuestDate<-current_date;
     		 self.compteur<-0.0; //max 1 
     	}
     	}	

   transition to: nymph when:  self.Diapause=false and self.BehState="m" and self.moulted /*and self.age>=  450*/{
   	//write self.age;
   //	write current_date; 
       self.BehState<-"q";
      self.PrevBehState<- copy(self.BehState); 
         //self.PrevBehState<-"q";
      self.compteur<-0.0;
   }
}
state nymph { 
	enter {
	      self.compteur<-0.0;
		 self.incubation<- false ; 
		self.oviposition <-false;
		self.moulted<-false;
	   self.NeighHosts<-[];
	  self. EntDiapause<-nil;
	  self.BehStateBeforeDia<- nil; 
	  self.AttachDetachDate<- nil;
	    self.MoultingDuration<-0;
	  //self.QuestDate<-current_date;
	  self.compteur<-0.0;
	 if self.PrevBehState="m" {
     self.BehState<-"m"; // je l'ai changé en moulting car les nymphes en hiver sont en fin du cycle 
     self.QuestDate<-current_date;
     self.compteur<-0.0;
     }
     	else {
     		self.BehState<-"q";
     		 self.QuestDate<-current_date;
     		 self.compteur<-0.0;
     	}
	}	 
 transition to: adult when: self.Diapause=false and self.BehState="m" and  self.moulted {
 //write current_date;
 self.BehState<-"q";
 self.PrevBehState<- copy(self.BehState); 
 self.moulted<-false;
//write " I am an adult "; 
//write self.state; 
}
}
state adult final:true{
	enter {
		self.color_vector<- #red; 
		 self.incubation<- false ; 
		self.Laid<-false; // attribut qui active la mortalité de l'individu une fois la ponte est terminée 
		 //self.MoultingDuration<-0;
		self.moulted<-false;
	   self.NeighHosts<-[];
	   self.AttachDetachDate<- nil; 
     	self.BehState<-"q";
     	self. EntDiapause<-nil;
     	self.compteur<-0.0;
     	self.QuestDate<-current_date;
     	  self.BehStateBeforeDia<- nil; 
     	  
  if self.PrevBehState="m" { // ceci pour le cas d'initialisation 
     self.BehState<-"m"; // je l'ai changé en moulting car les nymphes en hiver sont en fin du cycle 
     //self.QuestDate<-current_date; 
     //write self.QuestDate;
     self.compteur<-0.0;
    // self.oviposition <-true;// si elle est true , cad les adultes sont en fin de preoviposition 
     }
     	else {
     		self.BehState<-"q";
     		 self.QuestDate<-current_date;
     		 self.LayingEgg<-false;
     		 self.compteur<-0.0;
     		 self.oviposition <-false;
     	}
     	}
}
 

/************************************************************Diapause submodel***************************************************************************** */
 reflex Diapause when: every(#day) {
 	if self.state="egg"  {
 		if (CurrentTemp<=THRESHOLD_T_E)  and (self. EntDiapause=nil) {
 			
 			self.Diapause<- true; 
 		    self.EntDiapause <- current_date; // date d'entrée en diapause 
 		}
 			else { 
 				if (CurrentTemp>THRESHOLD_T_E) and (self. EntDiapause!=nil) {
 				self.Diapause<-false;

 			self. EntDiapause<-nil;
 				}
 				
   	}
 }
 if self.state="larva"  { 
	if (CurrentTemp<THRESHOLD_T_L)  and (self. EntDiapause=nil){
 		self.Diapause<- true; 
 		self.EntDiapause <- current_date; 
 		//write self.EntDiapause; 
 		self.BehStateBeforeDia<-nil;
 		if self.BehStateBeforeDia=nil {
 		self.BehStateBeforeDia<- self.BehState; 
 	    }
 	    	    self.BehState<- nil; 
 	}
 		else {
 			if (CurrentTemp>=THRESHOLD_T_L)  and (self. EntDiapause!=nil){
 				//write "date dortie dipau" + current_date;
 		self.BehState <- self.BehStateBeforeDia; 
 			self.Diapause<-false;
 			self. EntDiapause<-nil;
   	}
   	 }
 }
 if self.state="nymph"{
 	if (CurrentTemp<THRESHOLD_T_N)  and (self. EntDiapause=nil){
 		self.Diapause<- true; 
 		self.EntDiapause <- current_date; 
 		//write self.EntDiapause; 
 		self.BehStateBeforeDia<-nil;
 		if self.BehStateBeforeDia=nil {
 		self.BehStateBeforeDia<- self.BehState; 
 	    }
 	    	    self.BehState<- nil; 
 	}
 		else {
 			if (CurrentTemp>=THRESHOLD_T_N)  and (self. EntDiapause!=nil){
 				//write "date dortie dipau" + current_date;
 		self.BehState <- self.BehStateBeforeDia; 
 			self.Diapause<-false;
 			self. EntDiapause<-nil;
   	}
   	 }
   	// write  "nymphe dia " +self.Diapause; 
 }
if self.state="adult"{
	//write CurrentTemp;
 	if (CurrentTemp<=THRESHOLD_T_A) and (self. EntDiapause=nil)  {
 		self.Diapause<- true; 
 		  self.EntDiapause <- current_date; 
 		 // write self.EntDiapause; 
 		  self.BehStateBeforeDia<-nil;
 		  if self.BehStateBeforeDia=nil {
 		self.BehStateBeforeDia<- self.BehState; 
 		
 		 }
 		  self.BehState<- nil; 
 	}
 	else {
 		if (CurrentTemp>=THRESHOLD_T_A)  and (self. EntDiapause!=nil){
 			//write "date dortie dipau" + current_date;
 			self.BehState <- self.BehStateBeforeDia; 
 			self.Diapause<-false;
 			self. EntDiapause<-nil;
     	} }

 }
 }

 // l'idée est de mettre en mémoire les dates d'entrée sortie dipause , mais le problème  le reflex dipause est journalier , les dates  s'écrase 
 //chaque jour 

 /*****************************************************move vector submodel ****************************************************************** */
/*reflex move_vector when:  self.state!="egg"{
	if HostSeeking=true{
		self.speed <- rnd(MIN_V_SPEED,MAX_V_SPEED) with_precision 2; 
		do wander speed: self.speed; 
		 }
	else { 
		self.speed<-0.0 with_precision 2;
		 }
}*/
/***************************************************************attach submodel**************************************************************************** */
/*reflex  attach when: self.Diapause=false and  self.BehState= "q" and self.state!= 'egg'{
	if self.state="larva" {
		self.NeighHosts<- rodent at_distance PERCEPTION_DISTANCE ;
	  }
  else{
  	self.NeighHosts<-  (rodent+cattle) at_distance PERCEPTION_DISTANCE;
  	}
	 if length(self.NeighHosts)!=0{
	 	float ProbIndAttach<- 1-(0.1)^(length(self.NeighHosts)) with_precision 2;
	 	if flip(ProbIndAttach) {
	 		self.TargetHost <- one_of(self.NeighHosts);
	 		self.BehState<-"f" ;
	 		self.AttachDetachDate <- current_date; 
	 			 	//write self.BehState;
	 		 ask self.TargetHost {
	 		 	self.VectorOfParasite<- self.VectorOfParasite+myself;
	 		 	}
	 		 	} 
	 		 	} 	
	 	
}*/
reflex  attach_carrying when: self.Diapause=false and  self.BehState= "q" and self.state!= 'egg'{
	if self.state="larva" {
		self.NeighHosts<- rodent at_distance PERCEPTION_DISTANCE ;
	  }
  else{
  	self.NeighHosts<-  (rodent+cattle) at_distance PERCEPTION_DISTANCE;
  	}
	 if length(self.NeighHosts)!=0{
	 	float ProbIndAttach<- 1-(0.1)^(length(self.NeighHosts)) with_precision 2;
	 	if flip(ProbIndAttach) {
	 		self.TargetHost <- one_of(self.NeighHosts);
	 		
	 			 	//write self.BehState;
	 		 ask self.TargetHost {
	 		 	if  length(self.VectorOfParasite)<= parasite_max{
	 		 	self.VectorOfParasite<- self.VectorOfParasite+myself;
	 		 	 //	write "length of  " + length(self.VectorOfParasite);
	 		 	 	myself.BehState<-"f" ;
	 		        myself.AttachDetachDate <- current_date; 
	 		        //write "feeding " + myself.BehState;
	 		 	}
	 		}
	 		//write  self.BehState ;
	 		 	} 
	 		 	} 	
	 	
}
/*******************************************************************detach submodel************************************************************************ */
reflex detach when: self.BehState="f" and after(self.AttachDetachDate plus_days AttachToDetach){
		//t_init_detach<- machine_time; 
	 //benchmark "detach";
	self.location<- self.location +{rnd(1)#m,rnd(1)#m};// tells the  vector to be  located close to  the host from which is detached
	
	self.BehState<-"m";   
	if self.TargetHost!= nil{
	ask self.TargetHost {
		self.VectorOfParasite<- self.VectorOfParasite-myself;
		}
		self.TargetHost<-nil;
			//write self.BehState;
        if self.state="adult" {
       	self.LayingEgg<- flip(ProbToLay)? true:false;// sex ratio 1/2  à renommer
    	    	/*if self.LayingEgg= false {
    	    		self.killme <- true; 
    	    		TotalDeadAdult<-TotalDeadAdult+1;	
 		    do die;   //why did I put this here ? à vérifier 
    	    		}*/
}}}
/***************************************************************moulting submodel********************************************************************* */
reflex moulting when: (self.state!="egg" and self.state!="adult") and self. BehState="m" and self.Diapause=false and  self.moulted=false and every(1 #day){
	if self.state="larva"{
		MoultingDuration  <-0.0;
	 MoultingDuration  <-world.function_premoult_larva(CurrentTemp,OptimalTempMin, OptimalTempMax);  //  à revoir  avec durée d'incubation 
 	 //write  MoultingDuration;
 	 if MoultingDuration>0.0{
 	  self.compteur<- self.compteur+ (1/self.MoultingDuration); 
 	  self.moulted<- world.function_test(self.compteur);
 	 //  write " prevBehState larva "+ self.PrevBehState;
 	 //write self.compteur; 
  
 }
 }
 if self.state="nymph"{
 	MoultingDuration  <-0.0;
	 MoultingDuration  <-world.function_premoult_nymph(CurrentTemp,OptimalTempMin_ovi, OptimalTempMax_ovi);  //  à revoir  avec durée d'incubation 
 	// write "test " + MoultingDuration; 
 	 if MoultingDuration>0.0{
 	  self.compteur<- self.compteur+ (1/self.MoultingDuration); 
 	  self.moulted<- world.function_test(self.compteur);
 //write "prevBehState nymphe " +self.PrevBehState;
 }
 

}
 // write self.PrevBehState;
}
/*****************************************preoviposition submodel **************************************************************** */
reflex preoviposition when: self.LayingEgg=true and !self.Diapause and self.state="adult" and self.BehState= "m" and self.oviposition=false and every(#day){
	 PreoviToOvi <- 0.0;
	 PreoviToOvi  <-world.function_Preoviposition(CurrentTemp,OptimalTempMin_ovi, OptimalTempMax_ovi);  //  à revoir  avec durée d'incubation 
 	//write PreoviToOvi; 
 	if PreoviToOvi>0.0{
 	  self.compteur<- self.compteur+ (1/PreoviToOvi); 
 	  self.oviposition<- world.function_test(self.compteur);
 	 // write  "oviposition " + self.oviposition; 
}
}
/********************************************oviposition submodel ******************************************************************** */
reflex oviposition when: self.state="adult" and self.Diapause=false  and self.oviposition=true and self.BehState="m" and self.Laid=false {
	point motherloc<- copy(self.location);
	//write 'psst"';
	create vector number: int(fecundity) {
 	   		//write "I am new " ;
 	   		//write current_date; 
 		 	self.LayDate<- current_date; 
 	 		self.state<-"egg";
 	 		self.location<-  motherloc;
 	  		//self.location<- self.location +{rnd(1)#m,rnd(1)#m} with_precision 2;// tells the  vector to be  located close to  the host from which is detached
 	} 
 			self.Laid<-true;	
 			//write "I am dead" ;
 			TotalDeadAdult<-TotalDeadAdult+1;	
 		    do die;
}
/****************************************************************************incubation submodel********************************************************* */
 reflex incubation when:self.state="egg" and self.Diapause=false and self.LayDate!=nil and  after(self.LayDate) and  self.incubation=false  and every(#day) {
     LaidToIncubation<-0.0;
 	 LaidToIncubation<- world. function_IncubationDuration(CurrentTemp,OptimalTempMin_inc, OptimalTempMax_inc); 
 	 //write "test" +LaidToIncubation;
 	 if LaidToIncubation>0.0 {
 	self.compteur<- self.compteur+ (1/self.LaidToIncubation); 
 	self.incubation <-world.function_test(  self.compteur);
 	//write "incubation "+  self.incubation; 
 	}
 	}

/*******************************************************************natural mortality submodel******************************************** */
reflex natural_mortality  when: every( 1 #day) { // j'ai chnagé ça en se basant sur l'article de ogden 2005 

	 
	 //death by stravation whn questing 
if self.BehState="q" and self.Diapause=false and self.QuestDate!=nil and   (current_date- self.QuestDate)>=TimeDieQuesting{  // à mettre max 1 mois 
//write  (current_date- self.QuestDate) =TimeDieQuesting;
//write "here";

 		if self.state="larva"{
 			// write "here";
 	      //self.DeadLarvaStarv<-true;
    		TotalDeadLarva<- TotalDeadLarva + 1  ; 
    		do die;
    		 }
    	if self.state="nymph"{
    		//self.DeadNymphStarv<-true;
    			//write "nymph";
    		TotalDeadNymph <- TotalDeadNymph + 1; 
    		do die; 
    		 }
    	if self.state="adult"{
    		//self.DeadAdultStarv<-true;
    		//	write "adult dead";
    		TotalDeadAdult <- TotalDeadAdult + 1; 
    		do die; 
    		}
 	}
 	//********************************************mortalité naturelle 
 	  if self.state="egg"   {
 		if flip(P_NAT_MOR_E){
 			//self.DeadEggNat<-true;
 			TotalDeadEgg <- TotalDeadEgg + 1;
 			do die; 
 		}
 	}

 	if self.state="larva" {
 	
 		if flip(P_NAT_MOR_L ) {
 			//write 'h';
 			//self.DeadLarvaNat<-true;
    		TotalDeadLarva<- TotalDeadLarva + 1  ; 
    		do die;
    	    }
    }
    if self.state="nymph"{
    	
    	if flip(P_NAT_MOR_N) {
    		//self.DeadNymphNat<-true;
    		TotalDeadNymph <- TotalDeadNymph + 1; 
    		do die; 
    	}	
    }
    if self.state="adult"{
    	if flip(P_NAT_MOR_A) {
    	//self.DeadAdultNat<-true;
    	//write self.DeadAdultNat;
    		TotalDeadAdult <- TotalDeadAdult + 1; 
    		do die; 
    	}	
    
    }
    }

/*reflex density_dependent_mortality when: !self.Diapause and self.BehState="f" and self.state!= "egg" and current_date=( self.AttachDetachDate plus_days TimeDieAttach ){
 //   t_init_dens<- machine_time; 
    	float P_ddm;
    	ask self.TargetHost {
    	P_ddm<- 1-(P_DIE)^(length(self.VectorOfParasite)) with_precision 2;  //vérifié avec slimane déjà 
    	//write "proba ddm"+ P_ddm;
    	}
    	if flip(P_ddm) {
    		if self.state="larva"{
    			//write "hh";
    		TotalDeadLarva<- TotalDeadLarva + 1  ; 
    		do die; 
    		}
    		if self.state="nymph"{
    			//write "nymph";
    		TotalDeadNymph <- TotalDeadNymph + 1; 
    		do die; 
    		}
    		if self.state="adult"{
    			//write "adult dead";
    		TotalDeadAdult <- TotalDeadAdult + 1; 
    		do die; 
    		}
    	}

   }
 /**********************************************************environmental mortality******************************************************************** */	
 reflex environment_induced_mortality when:  every(1#day){
 	if self.state="egg" and ((CurrentTemp>= LETHAL_TEMP_SUP_E) or ( CurrentTemp<= LETHAL_TEMP_INF_E)){
 		float p_env<- world.function(LETHAL_TEMP_SUP_E,LETHAL_TEMP_INF_E, CurrentTemp) with_precision 2;
 		//write p_env;
 		 if flip(p_env) {
 		 	//DeadEggEnv<-true;
    		TotalDeadEgg<- TotalDeadEgg + 1; 
    		do die; 
    		}
    		}
 	if self.state="larva" and  ((CurrentTemp>= LETHAL_TEMP_SUP_L) or (CurrentTemp<= LETHAL_TEMP_INF_L)){
 		 float p_env<- world.function(LETHAL_TEMP_SUP_L,LETHAL_TEMP_INF_L, CurrentTemp);
 		if flip(p_env) {
 			//self.DeadLarvaEnv<-true; 
 			TotalDeadLarva<- TotalDeadLarva + 1; 
 				//write LETHAL_TEMP_INF_A;
 			do die; 
 			}
 			}
 	if self.state="nymph" and ((CurrentTemp>= LETHAL_TEMP_SUP_N or CurrentTemp<= LETHAL_TEMP_INF_N)){
    		 float p_env<- world.function(LETHAL_TEMP_SUP_N,LETHAL_TEMP_INF_N, CurrentTemp);
    		 if flip(p_env) {
    		 	//self.DeadNymphEnv<-true;
    		 	TotalDeadNymph <- TotalDeadNymph + 1; 
    		 	do die; 
    		 	}
    			}
    if self.state="adult" and ((CurrentTemp>= LETHAL_TEMP_SUP_A or CurrentTemp<= LETHAL_TEMP_INF_A)){
    		 float p_env<- world.function(LETHAL_TEMP_SUP_A,LETHAL_TEMP_INF_A, CurrentTemp);
    		 if flip(p_env) {
    		 	//self.DeadAdultEnv<- true;
    		 	TotalDeadAdult <- TotalDeadAdult + 1; 
    		 	do die; 
    		 	}
    			}
  
    }
 /**********************************************Control strategy***************************************************** */
   /*reflex acaricide_application when:  TCS  every(1  #week) {
 	if self.state="larva" {
 		if flip((P_NAT_MOR_L/8)+ P_ACAR) {
 			//write 'h';
 			TotalAcaricdesLarva<-TotalAcaricdesLarva+1;
    		TotalDeadLarva<- TotalDeadLarva + 1  ; 
    		do die;
    	    }
 }	    
  	if self.state="nymph" {
 		if flip((P_NAT_MOR_N/8)+ P_ACAR) {
 			//write 'h';
 			TotalAcaricdesNymph<-TotalAcaricdesNymph+1;
    		TotalDeadNymph<- TotalDeadNymph + 1  ; 
    		do die;
    	    }
 }	   
 }
 * 
 ***/
 }
species Host skills:[moving]{
     
	 list<vector> VectorOfParasite;
     float range <- minimal_distance;
	 point velocity <- {0,0};
	 float myspeed;
	 //rgb color_host <- #black;    
	 float size_host<-2.5 #m; 
	 //path path_to_follow1 <-path([{500#m,500#m},{450#m,550#m},{500#m,600#m},{550#m,600#m},{550#m,700#m},
	 	        											//{700#m,600#m},{650#m,400#m},
	 														//{500#m,400#m},{450#m,400#m},{400#m,400#m},{450#m,550#m}]);
	path path_to_follow1 <-path([{500#m,500#m},{550#m,650#m},{600#m,700#m},{650#m,700#m},{650#m,800#m},
	 	        											{800#m,700#m},{750#m,300#m},
	 														{600#m,500#m},{550#m,800#m},{350#m,350#m},{250#m,350#m},{500#m,500#m}]);

 path path_following<- path_to_follow1;
	action move_host_random  {
		    	do wander  speed: self.myspeed; 
	}
	
 reflex move_my_parasite{
 	ask VectorOfParasite {
 		self.location<-myself.location with_precision 2;
 	}
 }
}
species rodent parent: Host {
		
          reflex move_rodent {
            	do move_host_random;
            }
 /***********************************************************visualization****************************************************************************** */  
	         aspect base_rodent {
          draw triangle(size_host*10) color: #darkred;
           
           }  
	}
	
species cattle parent: Host{
	
	  	rgb color_host <- #black;      
	  	bool rest<- false;
	  	aspect base_cattle {
	  draw circle(size_host) color: color_host; 
	  //We loop on all the edges of the path the agent follow to display them
	  	loop seg over: path_following.edges {
	  		draw seg color: color;
	 	 }
	  
	
	}	 
   reflex follow_path /*when:self=leader*/{

if (current_date.hour >= (START_ACTIVE_TIME/3600) and current_date.hour < (END_ACTIVE_TIME/3600)){
	self.myspeed<-  rnd(MIN_H_SPEED,MAX_H_SPEED) with_precision 2;
	path path_followed <- follow(path: path_following, speed: myspeed,return_path: true);
	//do move_host_random;
	self.rest<-false; 
  //  write "cattle outside"; 	             
 }
else {
	//write START_ACTIVE_TIME; 
 	if  /*true or*/ (current_date.hour < (START_ACTIVE_TIME/3600) or current_date.hour>=(END_ACTIVE_TIME/3600) ){
 		do goto target: HERD_LOC /*speed:myspeed*/;	
 		  self.rest<-true; 
 		self.myspeed<-0.0 #km/#h; 
		    	   		    	//write "Cattle  in barn"	;
 }
 }
 }	
//Reflex used when the separation is applied to change the velocity of the boid
	reflex separation when: self!=leader {
		point acc <- {0,0};
		ask (cattle overlapping (circle(minimal_distance)))  {
			acc <- acc - ((location) - myself.location);
		}  
		velocity <- velocity*0.001+ acc;
	}
	
//Reflex to align the boid with the other boids in the range
	reflex alignment when: self!=leader {
		list others  <- ((cattle overlapping (circle (range)))  - self);
		point acc <- mean (others collect (each.velocity)) ;
		velocity <- velocity+  acc;  /*(acc /(rnd( alignment_factor)+1))*0.001 ;*/
		
		//write ' test';
	}
	 

//Reflex to apply the cohesion of the boids group in the range of the agent
	reflex cohesion when: self!=leader{
		list others <- ((cattle overlapping (circle (range)))  - self);
		point mass_center <- (length(others) > 0) ? mean (others collect (each.location)) : location;

		point acc <- mass_center - location;
		velocity <- (velocity *0.1)+ acc ;   
	}
	
action move_boids{  
		
		if (((velocity.x) as int) = 0) and (((velocity.y) as int) = 0) {
			velocity <- {(rnd(2)), (rnd(2)) };
		}
		point old_location <- copy(location);
		
		do goto target: (location + velocity) ;
		//write "hi'";
	//	velocity <- location - old_location;	


	}	
	reflex follow_leader {
	do goto  target: leader.location  ;
 	/*if  leader.rest=false{
	    do move_boids;
	    }*/
	}
	}	
/*******************************************************************visualization****************************************************************** */	


	
//l'étble comme nouvelle espèce 
species etable{
	aspect test{
		draw shape color:#darkred;
	}

}	

	

/**********************************************************************************************************************************************************************************************************
 * ************************************************************************************test experiment***************************************************************************************************
 ********************************************************************************************************************************************************************************************************** */
 
 
 
 
 
experiment test type: gui /*benchmark:true*/ /*keep_seed:true*/{
		//string rng<- "cellular";
		//float seed <-  2.0;
	
		/************************************************************Host parameters******************************* */
	 parameter"INI_NUM_CATTLE"  var:INI_NUM_CATTLE<- 20 min:0 category: "Host";
	parameter"INI_NUM_RODENT"  var:INI_NUM_RODENT<- 30 min:0	 category: "Host";
	/************************************************Vector parameters*************************************/ 
     parameter "INI_NUM_VECTOR" var: INI_NUM_VECTOR<-150 min: 1 category:"Vector";
     parameter "LETHAL_TEMP_SUP_L "  var: LETHAL_TEMP_SUP_L<-35  min:30    category:"Vector"; //Larva Superior Lethal TEMP
	 parameter " LETHAL_TEMP_SUP_N" var: LETHAL_TEMP_SUP_N<-35 min:20  category:"Vector";
	 parameter "LETHAL_TEMP_SUP_E" var:LETHAL_TEMP_SUP_E<-35 min:30  category:"Vector";
	 parameter "LETHAL_TEMP_SUP_A" var:LETHAL_TEMP_SUP_A<-35 min:30 category:"Vector";
	 parameter "LETHAL_TEMP_INF_N"  var:LETHAL_TEMP_INF_N<- -15 min:-30 max: 50category:"Vector";
	 parameter "LETHAL_TEMP_INF_A "  var:  LETHAL_TEMP_INF_A<- -15 min:-30 max: 50 category:"Vector";
	 parameter "LETHAL_TEMP_INF_L" var:LETHAL_TEMP_INF_L <- -15 category:"Vector";
	 parameter "LETHAL_TEMP_INF_E" var: LETHAL_TEMP_INF_E<- -15   category:"Vector"; 	
	
	 parameter "PERCEPTION_DISTANCE" var: PERCEPTION_DISTANCE<- 5 #m  category:"Vector"; 
	 parameter"ProbToLay"  var:ProbToLay<-1.0 min:0.0 max:1.0 category:"Vector"; //probability to lay egg ( only for adult) 
     parameter "P_NAT_MOR_N" var: P_NAT_MOR_N<-   0.002/*0.002003240*/ min:0.0 max:1.0 category:"Vector";
     parameter "P_NAT_MOR_L"  var:  P_NAT_MOR_L<- 0.004 /*0.002002988*/ min:0.0 max:1.0 category:"Vector"; 
     parameter "P_NAT_MOR_E"  var:  P_NAT_MOR_E<- 0.006 /*0.001006363*/ min:0.0 max:1.0 category:"Vector"; 
     parameter "P_NAT_MOR_A"  var:  P_NAT_MOR_A<- 0.002 /*0.001006363*/ min:0.0 max:1.0 category:"Vector";     
     // parameter "P_DIE" var: P_DIE<-0.99 min:0.0 max:1.0 category:"Vector";
  	 parameter "P_ATTACH" var:P_ATTACH<-0.7  min:0.0 max:1.0 category:"Vector";
  	 
     //parameter  "TimeDieAttach "  var:TimeDieAttach <-4  min: 1 category:"Vector"; //Time to die when attached 
	 parameter "AttachToDetach"  var: AttachToDetach<-7  min: 1 max:10 category:"Vector"; // Duration of attachment until detachment 
   	// parameter "DetachToMoultLarva" var: DetachToMoultLarva<- 42 min: 1 category:"Vector" ; //Duration of detachment until moulting for larva kocan 
	 //parameter "DetachToMoultNymph"  var:DetachToMoultNymph<- 30 min: 1 category:"Vector"; //Duration of detachment until moulting for nymph nymphal moltig to adult kocan
	 //parameter "DetachToPreovi" var:DetachToPreovi<-7  min:1 max: 56 category:"Vector"; //Duration of detachment until preoviposition ( only for Adult, equivalent to DetachToMoult in larva ana nymph) kocan 
	 parameter "HostSeeking" var:HostSeeking<-false  category:"Vector";
	 parameter "TimeDieQuesting" var: TimeDieQuesting<-  14463900.0 min: 0.0 max: 13140014400.0 category:"Vector" ; //Time  to die when questing ( if not attached)
	//5.5m ois = 14463900.0
	// 3 mois 7889400
	 parameter "fecundity"  var: fecundity<- 5.0 min: 0.0 max: 3000.0 category:"Vector"; //Hypothe fecundity
	// parameter "FecCoef" var:FecCoef<-1.4  min: 0.0 category:"Vector";
	 parameter "THRESHOLD_T_N" var: THRESHOLD_T_N <-  4.0 category:"Vector"; //threshold TEMP_TUNISIA for diapause for Nymph 
     parameter "THRESHOLD_T_L" var: THRESHOLD_T_L<- 2.0 category:"Vector"; //threshold TEMP_TUNISIA for diapause for larva 
     parameter "THRESHOLD_T_E" var: THRESHOLD_T_E<- 1.0  min: -15.0 max: 35.0 category:"Vector"; //threshold temperature for diapause for egg
     parameter "THRESHOLD_T_A" var:THRESHOLD_T_A<- 4.0 category:"Vector"; //threshold temperature for diapause for Adult
     parameter "id" var: id<-1  category:"Simulation"; 
     
     //carrying capacity 
     parameter "parasite_max" var: parasite_max<- 3.0  min: 0.0 max: 100.0 category:"Host"; 
     // acaricides parameters 
     
     parameter "TCS" var: TCS<-false category:"Environment" ;
     parameter " P_ACAR" var:  P_ACAR <-0.001 min:0.0 max:1.0 category:"Environment";
     
output /*synchronized: true*/{
		//monitor "Total vector" value:length(vector);   
		//monitor "TEMP" value:CurrentTemp;
	   //monitor  "current date" value:current_date;
		//monitor "moulting" value: vector count(each.BehState="m");
		//monitor "feeding" value: vector count(each.BehState="f");
		//monitor "questing" value: vector count(each.BehState="q");
		//monitor "nb vector" value: length(vector as list);
		//monitor "nb hosts" value: INI_NUM_HOST;
	   // monitor "nb cattle" value: INI_NUM_CATTLE;
		//monitor "nb rodents" value: INI_NUM_RODENT;
		//monitor "nb dipause" value: vector count(each.Diapause);
		//monitor "nb egg" value: vector count(each.state="egg");
		
		/*monitor "TotalDeadLarva" value: TotalDeadLarva;
		monitor "TotalDeadEgg" value: TotalDeadEgg;
		monitor "TotalDeadAdult" value: TotalDeadAdult;
		monitor "TotalDeadNymph" value: TotalDeadNymph;
	   monitor "Total larva" value: vector count(each.state="larva"); 
	    monitor "Total egg" value: vector count(each.state="egg"); 
	   monitor "Total nymph" value: vector count(each.state="nymph");
	   monitor "Total adult" value: vector count(each.state="adult");*/
		
	    //monitor "Total diapause" value: vector count(each.Diapause=true );  
		/*monitor "Total quest" value: vector count(each.BehState="q"); 
	    monitor "Total feed" value:  vector count(each.BehState="f"); 
	    monitor "Total moult" value: vector count(each.BehState="m");*/
	    //monitor "Total active" value: vector count(each.Diapause=false);
	    //monitor "nymph questing" value:vector count(each.state="nymph" and each.BehState="q");
	   // monitor " adult questing" value:vector count(each.state="adult" and each.BehState="q");
	    /*monitor "nymph moulting" value:vector count(each.state="nymph" and each.BehState="m");
	      monitor "nymph feeding" value:vector count(each.state="nymph" and each.BehState="f");
	    monitor " larva questing" value:vector count(each.state="larva" and each.BehState="q");
	    monitor "larva  moulting" value:vector count(each.state="larva" and each.BehState="m");
	    monitor "larva feeding" value:vector count(each.state="larva" and each.BehState="f");
	   monitor "dipause larva" value: vector count(each.state="larva" and each.Diapause);
	   monitor "dipause nymph" value: vector count(each.state="nymph" and each.Diapause);*/
	 //monitor "LaidToIncubation" value:LaidToIncubation ;
	   //monitor "TCS" value: TCS;*/
		
		
		
		display main_display{
			//grid environment lines: #black;
				
			species etable aspect:test;
			species vector aspect:base_vector; 
			species cattle aspect: base_cattle;
			species rodent aspect: base_rodent; 
			
				}
		layout #split toolbars: false;
	display adult_behavior_state refresh: every(1 #days)  type: java2D {
			chart " adult behavior state" type: series background: #lightgray style: spline x_serie_labels: current_date.month x_label: "Date"
			x_tick_values_visible: true{
				data "questing" value: vector count( each.state= "adult" and each.BehState="q") color: #darkorange  ;
				data "feeding" value: vector count(each.state='adult' and each.BehState="f") color: #darkslateblue style: spline; 
				data "preoviposition" value: vector count(each.state='adult' and each.BehState="m") color: #darkgreen; 
				data "Diapause" value: vector count(each.state='adult' and each.Diapause) color: #darkred  marker_shape: marker_circle marker_size: 3;
				//data "Active" value: vector count(each.Active=false) color:#cyan;
				
		}
		}
	display nymph_behavior_state refresh: every(#day)  type: java2D {
			chart "nymph  behavior state" type: series background: #lightgray style: spline x_serie_labels: current_date.month x_label: "Date"
			x_tick_values_visible: true{
				
				data "feeding" value: vector count(each.state='nymph' and each.BehState="f") color: #darkslateblue style: spline; 
				data "moulting" value: vector count(each.state='nymph' and each.BehState="m") color: #darkgreen; 
				data "Diapause" value: vector count(each.state='nymph' and each.Diapause) color: #darkred  marker_shape: marker_circle marker_size: 3;
				data "questing" value: vector count( each.state= "nymph" and each.BehState="q") color: #darkorange  ;
				//data "Active" value: vector count(each.Active=false) color:#cyan;
				
		}
		}
			display larva_behavior_state refresh: every(#day)  type: java2D {
			chart "larva behavior state" type: series background: #lightgray style: spline x_serie_labels: current_date.month x_label: "Date"
			x_tick_values_visible: true{
				
				data "feeding" value: vector count(each.state='larva' and each.BehState="f") color: #darkslateblue style: spline; 
				data "moulting" value: vector count(each.state='larva' and each.BehState="m") color: #darkgreen; 
				data "Diapause" value: vector count(each.state='larva' and each.Diapause) color: #darkred  marker_shape: marker_circle marker_size: 3;
				data "questing" value: vector count( each.state= "larva" and each.BehState="q") color: #darkorange  ;
				//data "Active" value: vector count(each.Active=false) color:#cyan;
				
		}
		}
  display vector_state refresh:every( #day) type: java2D {
    	chart "life stages" type: series style: spline x_serie_labels: current_date.month x_label: "Date" background: #lightgray  {
    		data "egg" value: vector count(each.state="egg") color: #yellow;
    		data "larva" value: vector count(each.state="larva")  color: #green;
    		data "nymph" value: vector count(each.state="nymph") color: #blue;
    		data "adult" value: vector count(each.state='adult') color: #red; 
    		data"total" value: length(vector) color:#black;	
    	}
    }
      /*display egg_state refresh:every( #day) type: java2D {
    	chart " egg incubation" type: series style: spline x_serie_labels: current_date.month x_label: "Date" background: #lightgray  {
    		data "egg" value: vector count(each.incubation=true) color: #yellow;
    		//data "larva" value: vector count(each.state="larva")  color: #green;
    		//data "nymph" value: vector count(each.state="nymph") color: #blue;
    		//data "adult" value: vector count(each.state='adult') color: #red; 	
    	}
    }*/
    /*display diapause_perstate refresh:every(  #day) type: java2D {
    	chart "diapause perstate" type: series style: spline x_serie_labels: current_date.month x_label: "Date" background: #lightgray  {
    		//data "incubation duration  per vector" value: vector.state   color:#yellow;
    		//data "larva" value: vector count(each.state="larva" and each.Diapause)   color: #green;
    		//data "nymph" value: vector count(each.state="nymph"and each.Diapause) color: #blue;
    		data "egg" value: vector count(each.state="egg"and each.Diapause) color: #yellow;
    		//data "adult" value: vector count(each.state="adult"and each.Diapause) color: #red;
    
    		
    	}
    }*/
   display vector_cumulative_mortality refresh:every( 3 #days) type: java2D {
    	chart "mortality" type: series background: #lightgray  style: spline x_serie_labels: current_date.month x_label: "Date"{
    	//	data "egg" value: TotalDeadEgg color: #yellow;
    	//	data "larva" value: TotalDeadLarva color: #green;
    		//data "nymph" value: TotalDeadNymph color: #blue;
    		data "adult" value: TotalDeadAdult color: #red; 

}}

   /*display vector_natural_mortality refresh:every( 1#day) type: java2D {
    	chart " natural mortality" type: series background: #lightgray  style: spline x_serie_labels: current_date.month x_label: "Date"{
    		data "egg" value: vector count(each.state="egg" and each.DeadEggNat) color: #yellow;
    		//data "larva" value: TotalDeadLarva color: #green;
    		//data "nymph" value: TotalDeadNymph color: #blue;
    		data "adult" value: vector count(each.state="adult" and each.DeadAdultNat)  color: #red; 

}}*/
 }
}






















