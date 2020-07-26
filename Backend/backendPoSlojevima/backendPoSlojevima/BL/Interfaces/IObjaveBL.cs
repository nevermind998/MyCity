using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.BL.Interfaces
{
    public  interface IObjaveBL
    {
        List<Objave> getAllObjave();
        void saveObjavu(PrihvatanjeObjave objava);
        public void deleteObjavuByIdObjave(long idObjave,int ind);
        public void deleteObjavuByIdKorisnika(long idKorisnika);

        List<Objave> getObjaveByIdKorisnika(long idKorisnika);
        long getIdKorisnikaByIdObjave(long idObjave);
        Objave getObjavaByIdObjave(long idObjave);
        public Objave problemResen(long idObjave,long ind);
        List<Objave> getReseneObjave();
        List<Objave> getObjaveByIdGradova(List<long> idGradova);
        List<Objave> getObjaveByIdGrada(long idGrada);
        List<Objave> getReseneObjaveByIdInstitucije(long idInstitucije);
        List<Objave> getAllObjaveByIdKorisnika(List<long> nizGradova);
        public List<Objave> getReseneObjaveByGradove(List<long> nizGradova);
        public List<Objave> getReseneObjaveByGrad(long idGrada);
        public List<Objave> getNereseneObjaveByGradZa7Dana(long idGrada);
        public List<Objave> getReseneObjaveByGradZa30Dana(long idGrada);
        public List<Objave> getNereseneObjaveByGradZa30Dana(long idGrada);
        
        List<Objave> getNereseneObjaveByGradove(List<long> nizGradova);
        List<Objave> getNereseneObjaveByGrad(long idGrada);
        List<Objave> getReseneObjaveByGradZa7Dana(long idGrada);

        List<Objave> getNereseneObjave();
        List<Objave> getNereseneProblemeByIdKorinsika(long idKorisnika);
        List<Objave> getReseneProblemeByIdKorinsika(long idKorisnika);

        public List<KategorijeProblema> getKategorijeProblema();
        public List<LepeStvari> getLepeStavri();
        public LepeStvari getLepeStavriById(long LepeStavriID);


    }
}
