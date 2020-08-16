using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.DAL.Interfaces
{
    public  interface IObjaveDAL
    {
        List<Objave> getAllObjave();
        void saveObjavu(PrihvatanjeObjave objava);
        public void deleteObjave(List<Objave> objave);
        public void deleteObjavu(Objave objava,int ind);
        public Objave problemResen(Objave objava,long ind);
        public List<KategorijeProblema> getKategorijeProblema();
        public List<LepeStvari> getLepeStavri();
        public LepeStvari getLepeStavriById(long LepeStavriID);



    }
}
