function [message]=verif_code(code_test)
  if exist('.backup')~=0 
    load -mat '.backup'
    masque=[0; 1; 0; 1; 1; 0; 1; 0]; % Le code que doit trouver l'étudiant
    code=xor(cypher,masque);
    if code==code_test 
      message='Bravo vous commencez a comprendre...';
    else
      message='Patience est mère de toutes les vertues ;-)';
    end
  else
    message='Vous n''avez pas généré de code! demandez au prof d''en générer un pour vous';
  end  
